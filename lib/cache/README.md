# Cache System

Sistema genérico de caché para repositorios en `stoyco_shared`.

## Características

- ✅ **Genérico**: Funciona con cualquier tipo de dato
- ✅ **TTL (Time-To-Live)**: Expiración automática de datos
- ✅ **Fácil integración**: Solo usa `RepositoryCacheMixin` en tu repositorio
- ✅ **Invalidación flexible**: Por key, múltiples keys, o patrones
- ✅ **Force refresh**: Opción para forzar actualización
- ✅ **Compatible con Either**: Funciona con `Either<Failure, T>`
- ✅ **Thread-safe**: Singleton compartido en toda la app
- ✅ **Completamente testeado**: Cobertura de tests completa
- ✅ **Persistente opcional**: Usa `PersistentCacheManager` para conservar datos tras reinicios (solo resultados exitosos y serializables)
- ✅ **Invalidación global**: Limpia todos los caches de todos los repositorios de una sola vez

## Instalación

El sistema de caché ya está incluido en `stoyco_shared`. Solo necesitas importarlo:

```dart
import 'package:stoyco_shared/stoyco_shared.dart';
```

## Uso básico

### 1. Agrega el mixin a tu repositorio

```dart
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/cache/repository_cache_mixin.dart';
import 'package:stoyco_shared/errors/errors.dart';

class EventRepositoryImpl with RepositoryCacheMixin {
  EventRepositoryImpl(this._eventDs);
  final EventDataSource _eventDs;

  Future<Either<Failure, Event>> getEventId(String eventId) async {
    return cachedCall<Event>(
      key: 'event_$eventId',
      ttl: Duration(minutes: 5),
      fetcher: () async {
        try {
          final event = await _eventDs.getEventId(eventId);
          return Right(event);
        } on DioException catch (error) {
          return Left(DioFailure.decode(error));
        }
      },
    );
  }
}
```

### 2. ¡Eso es todo!

La primera llamada a `getEventId('123')` hará la petición al API. Las siguientes llamadas dentro de 5 minutos devolverán el resultado cacheado.

## Cache persistente (experimental)

Si necesitas que ciertos resultados sobrevivan reinicios de la app (por ejemplo configuración remota o contenido relativamente estático), puedes usar `PersistentCacheManager`.

```dart
import 'package:stoyco_shared/cache/persistent_cache_manager.dart';
import 'package:stoyco_shared/news/models/new_model.dart';

final persistent = PersistentCacheManager(directoryPath: appSupportDir.path);

// Registra decoders para tipos que quieras reconstruir al leer del disco.
persistent.registerDecoder<NewModel>('NewModel', (json) => NewModel.fromJson(json));

// Asigna al repositorio (antes de usarlo)
newsRepository.cacheManager = persistent;
```

### Limitaciones actuales

- Solo se persisten resultados exitosos (`Right`) cuyos objetos tienen método `toJson()`.
- Los errores nunca se guardan.
- El tipo genérico se reconstruye dinámicamente; internamente se representa como `Right<Failure, dynamic>`. Si necesitas tipos estrictos tras reinicio, garantiza que el decoder correcto esté registrado antes de acceder.
- Si no hay decoder registrado para un tipo almacenado, el entry se omite silenciosamente.

### Cuándo usarlo

- Datos semiestáticos (segmentos de mercado, configuración de UI, banners, acceso).
- Evitar llamadas repetidas al iniciar la app.
- No recomendado para listas altamente dinámicas (feeds en tiempo real) o datos sensibles.

### Limpieza / invalidación

Funciona igual que el cache en memoria — las invalidaciones borran también del archivo persistente.

### Precaución de tamaño

El archivo `stoyco_cache.json` crece con cada entrada serializada. Define TTLs razonables y considera invalidar claves obsoletas para evitar crecimiento indefinido.

## Casos de uso

### Cache con diferentes TTLs

Ajusta el TTL según la volatilidad de tus datos:

```dart
// Datos que cambian poco: TTL largo
Future<Either<Failure, UserProfile>> getUserProfile(String userId) {
  return cachedCall<UserProfile>(
    key: 'user_profile_$userId',
    ttl: Duration(hours: 1), // Cache por 1 hora
    fetcher: () => _fetchUserProfile(userId),
  );
}

// Listas que cambian frecuentemente: TTL corto
Future<Either<Failure, List<News>>> getNews() {
  return cachedCall<List<News>>(
    key: 'news_feed',
    ttl: Duration(minutes: 2), // Cache por 2 minutos
    fetcher: () => _fetchNews(),
  );
}
```

### Force refresh (pull-to-refresh)

```dart
Future<Either<Failure, Event>> refreshEvent(String eventId) {
  return cachedCall<Event>(
    key: 'event_$eventId',
    ttl: Duration(minutes: 5),
    forceRefresh: true, // Ignora el cache y obtiene datos frescos
    fetcher: () => _fetchEvent(eventId),
  );
}
```

### Invalidar cache después de mutaciones

```dart
Future<Either<Failure, bool>> updateEvent(Event event) async {
  try {
    final result = await _eventDs.updateEvent(event);

    // Invalida caches relacionados después de actualizar
    invalidateCache('event_${event.id}');
    invalidateCache('top_events');

    return Right(result);
  } catch (error) {
    return Left(/* handle error */);
  }
}
```

### Invalidación por patrón

```dart
// Invalida todos los eventos cacheados
invalidateCachePattern('event_');

// Invalida todos los datos de un usuario
invalidateCachePattern('user_${userId}_');
```

### Limpiar todo el cache

```dart
// En tu repositorio (solo limpia el cache de ese repositorio)
void clearAllCache() {
  cacheManager.clear();
}
```

### Invalidación global (todos los repositorios)

El sistema ahora incluye `GlobalCacheManager` que rastrea automáticamente TODOS los `CacheManager` creados en la aplicación (tanto `PersistentCacheManager` como `InMemoryCacheManager`). Todos los caches se registran automáticamente al ser creados o asignados a un repositorio. Puedes invalidar caches de TODOS los repositorios de una sola vez:

```dart
import 'package:stoyco_shared/cache/repository_cache_mixin.dart';

// Limpiar TODOS los caches de TODOS los repositorios
RepositoryCacheMixin.clearAllRepositoryCaches();

// Invalidar una key específica en TODOS los repositorios
RepositoryCacheMixin.invalidateKeyGlobally('user_123');

// Invalidar por patrón en TODOS los repositorios
RepositoryCacheMixin.invalidatePatternGlobally('news_');
```

**Casos de uso comunes:**

- **Logout de usuario**: Limpia todos los caches al cerrar sesión
- **Cambio de ambiente**: Invalida caches al cambiar de producción a staging
- **Cambio de cuenta**: Limpia datos del usuario anterior
- **Reset de datos**: Cuando se detecta un problema de sincronización

**Ejemplo en un AuthService:**

```dart
class AuthService {
  Future<void> logout() async {
    // Limpiar todos los caches de todos los repositorios
    RepositoryCacheMixin.clearAllRepositoryCaches();

    // Continuar con logout...
    await _clearTokens();
    await _clearUserData();
  }
}
```

**Ejemplo para invalidar datos de un usuario específico:**

```dart
void onUserDataChanged(String userId) {
  // Invalida todos los caches relacionados con este usuario
  // en todos los repositorios de la app
  RepositoryCacheMixin.invalidatePatternGlobally('user_${userId}_');
}
```

### Invalidación desde el cliente (UI/Services)

Para facilitar el uso desde cualquier capa de la aplicación (UI, services, etc.), usa la clase `CacheUtils`:

```dart
import 'package:stoyco_shared/cache/cache_utils.dart';

// En un botón de logout
ElevatedButton(
  onPressed: () {
    CacheUtils.clearAllCaches();
    Navigator.pushReplacementNamed(context, '/login');
  },
  child: Text('Logout'),
)

// En un servicio de autenticación
class AuthService {
  Future<void> logout() async {
    await _clearTokens();
    CacheUtils.clearAllCaches(); // ✅ Fácil y directo
    await _navigateToLogin();
  }
}

// Invalidar datos específicos después de una actualización
class ProfileScreen extends StatelessWidget {
  Future<void> _updateProfile(String userId) async {
    await _profileService.updateProfile(userId);
    // Invalida todos los caches de este usuario
    CacheUtils.invalidatePattern('user_${userId}_');
    setState(() {});
  }
}

// Refrescar datos de noticias
class NewsScreen extends StatelessWidget {
  Future<void> _refreshNews() async {
    CacheUtils.invalidatePattern('news_');
    await _loadNews(forceRefresh: true);
  }
}
```

**Diferencia entre los métodos:**

- **`CacheUtils`**: Para usar desde UI, services, o cualquier capa de la app
- **`RepositoryCacheMixin`**: Para usar dentro de repositorios o cuando ya tienes el mixin
- **`GlobalCacheManager`**: Para uso avanzado o casos especiales (normalmente no necesario)

## API Reference

### RepositoryCacheMixin

#### `cachedCall<T>`

Ejecuta una llamada con cache automático.

**Parámetros:**

- `key`: Clave única para este cache
- `ttl`: Time-To-Live (duración de validez del cache)
- `fetcher`: Función que obtiene los datos si no están en cache
- `forceRefresh`: (opcional) Si es `true`, ignora el cache

**Retorna:** `Future<Either<Failure, T>>`

#### `invalidateCache(String key)`

Invalida (elimina) un cache específico.

**Retorna:** `bool` - `true` si se eliminó, `false` si no existía

#### `invalidateCacheMultiple(List<String> keys)`

Invalida múltiples caches a la vez.

#### `invalidateCachePattern(String pattern)`

Invalida todos los caches cuya key contenga el patrón.

#### `clearAllCache()`

Elimina todos los caches del repositorio actual.

#### `clearAllRepositoryCaches()` (static)

Limpia TODOS los caches de TODOS los repositorios en la aplicación.
Usa `GlobalCacheManager` internamente.

#### `invalidateKeyGlobally(String key)` (static)

Invalida una key específica en todos los repositorios.
Retorna el número de caches donde se encontró la key.

#### `invalidatePatternGlobally(String pattern)` (static)

Invalida todas las keys que contengan el patrón en todos los repositorios.
Retorna el número total de keys invalidadas.

### CacheUtils

Clase de utilidad para invalidar cache desde cualquier capa de la aplicación.

#### `clearAllCaches()` (static)

Limpia TODOS los caches de TODOS los repositorios.

#### `invalidateKey(String key)` (static)

Invalida una key específica en todos los repositorios.
Retorna el número de caches donde se encontró la key.

#### `invalidatePattern(String pattern)` (static)

Invalida todas las keys que contengan el patrón en todos los repositorios.
Retorna el número total de keys invalidadas.

#### `registeredCacheCount` (static getter)

Retorna el número de cache managers actualmente registrados.

### CacheManager

Si necesitas usar el cache directamente (raro):

```dart
final cache = InMemoryCacheManager();

// Guardar
cache.set('key', CacheEntry(
  data: myData,
  ttl: Duration(minutes: 5),
));

// Obtener
final entry = cache.get<MyType>('key');
if (entry != null && entry.isValid) {
  print(entry.data);
}

// Invalidar
cache.invalidate('key');

// Limpiar todo
cache.clear();
```

## Buenas prácticas

### ✅ DO

- Usa TTLs apropiados según la volatilidad de los datos
- Invalida caches después de mutaciones (POST, PUT, DELETE)
- Usa `forceRefresh` para funcionalidades de "pull-to-refresh"
- Agrupa invalidaciones relacionadas con patrones
- Documenta qué datos se cachean y por cuánto tiempo

### ❌ DON'T

- No uses TTLs extremadamente largos (> 1 hora) sin razón
- No olvides invalidar caches después de modificar datos
- No cachees datos sensibles sin considerar seguridad
- No uses el mismo `key` para datos diferentes
- No cachees respuestas con errores (el mixin ya lo hace automáticamente)

## Estrategias de cache

### Cache-First (recomendado para datos estables)

```dart
// Siempre intenta usar cache primero
return cachedCall<T>(
  key: 'stable_data',
  ttl: Duration(hours: 1),
  fetcher: () => _fetchData(),
);
```

### Network-First (recomendado para datos críticos)

```dart
// Siempre obtén datos frescos, pero ten fallback
final fresh = await cachedCall<T>(
  key: 'critical_data',
  ttl: Duration(minutes: 1),
  forceRefresh: true,
  fetcher: () => _fetchData(),
);

if (fresh.isLeft) {
  // Si falla, intenta usar cache antiguo como fallback
  final cached = cacheManager.get<Either<Failure, T>>('critical_data');
  if (cached != null) {
    return cached.data; // Puede estar expirado pero es mejor que nada
  }
}

return fresh;
```

### Stale-While-Revalidate

```dart
// Devuelve cache inmediatamente, pero revalida en background
Future<Either<Failure, T>> getWithSWR(String key) async {
  final cached = cacheManager.get<Either<Failure, T>>(key);

  // Si hay cache, devuélvelo inmediatamente
  if (cached != null) {
    // Revalida en background (no await)
    cachedCall<T>(
      key: key,
      ttl: Duration(minutes: 5),
      forceRefresh: true,
      fetcher: () => _fetchData(),
    );

    return cached.data;
  }

  // Si no hay cache, fetch normalmente
  return cachedCall<T>(
    key: key,
    ttl: Duration(minutes: 5),
    fetcher: () => _fetchData(),
  );
}
```

## Testing

El sistema incluye helpers para testing:

```dart
import 'package:stoyco_shared/cache/in_memory_cache_manager.dart';

void main() {
  setUp(() {
    // Limpia el cache singleton antes de cada test
    InMemoryCacheManager.resetInstance();
  });

  test('should cache results', () async {
    final repo = MyRepository();

    // Primera llamada
    await repo.getData('123');

    // Segunda llamada (cacheada)
    final result = await repo.getData('123');

    expect(result.isRight, isTrue);
  });
}
```

## Ejemplos completos

Ver [`lib/cache/example_usage.dart`](./example_usage.dart) para ejemplos completos y ejecutables.

## Troubleshooting

### El cache no se está usando

- Verifica que estés usando la misma `key` en ambas llamadas
- Asegúrate de que el TTL no haya expirado
- Revisa que no estés usando `forceRefresh: true`

### Datos obsoletos en el cache

- Reduce el TTL
- Invalida el cache después de mutaciones
- Considera usar `forceRefresh` en puntos críticos

### Tests fallan por cache compartido

- Usa `InMemoryCacheManager.resetInstance()` en `setUp()`
- O usa un `CacheManager` custom en tests:
  ```dart
  repository.cacheManager = InMemoryCacheManager();
  ```

## Contribuir

Al agregar nuevas funcionalidades:

1. Mantén la API simple y consistente
2. Agrega tests completos
3. Documenta con Dartdoc
4. Actualiza este README y el ejemplo

---

**Preguntas o problemas?** Abre un issue o contacta al equipo.

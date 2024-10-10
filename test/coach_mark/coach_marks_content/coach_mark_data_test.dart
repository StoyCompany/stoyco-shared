import 'package:flutter_test/flutter_test.dart';
import 'package:stoyco_shared/coach_mark/coach_marks_content/coach_mark_data.dart';

void main() {
  group('Coach Mark Data', () {
    test('Coach Mark Data should be created with correct values', () {
      const coachMarkData = CoachMarkData(
        title: 'Test Title',
        description: 'Test Description',
        button: 'Test Button',
        type: 'Test Type',
        step: 1,
        enableClose: true,
        enableNext: false,
      );

      expect(coachMarkData.title, 'Test Title');
      expect(coachMarkData.description, 'Test Description');
      expect(coachMarkData.button, 'Test Button');
      expect(coachMarkData.type, 'Test Type');
      expect(coachMarkData.step, 1);
      expect(coachMarkData.enableClose, true);
      expect(coachMarkData.enableNext, false);
    });

    test('Coach Mark Data should be created with default values', () {
      const coachMarkData = CoachMarkData();

      expect(coachMarkData.title, null);
      expect(coachMarkData.description, null);
      expect(coachMarkData.button, null);
      expect(coachMarkData.type, null);
      expect(coachMarkData.step, null);
      expect(coachMarkData.enableClose, null);
      expect(coachMarkData.enableNext, null);
    });

    test('Coach Mark Data should be created with updated values', () {
      const coachMarkData = CoachMarkData(
        title: 'Test Title',
        description: 'Test Description',
        button: 'Test Button',
        type: 'Test Type',
        step: 1,
        enableClose: true,
        enableNext: false,
      );

      final updatedCoachMarkData = coachMarkData.copyWith(
        title: 'Updated Title',
        description: 'Updated Description',
        button: 'Updated Button',
        type: 'Updated Type',
        step: 2,
        enableClose: false,
        enableNext: true,
      );

      expect(updatedCoachMarkData.title, 'Updated Title');
      expect(updatedCoachMarkData.description, 'Updated Description');
      expect(updatedCoachMarkData.button, 'Updated Button');
      expect(updatedCoachMarkData.type, 'Updated Type');
      expect(updatedCoachMarkData.step, 2);
      expect(updatedCoachMarkData.enableClose, false);
      expect(updatedCoachMarkData.enableNext, true);
    });
  });
}

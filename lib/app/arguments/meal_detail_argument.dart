import 'package:image_cropper/image_cropper.dart';

class MealResultArgument {
  final (String, String) mealName;
  final CroppedFile? croppedFile;

  const MealResultArgument(this.mealName, this.croppedFile);
}

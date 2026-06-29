import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  final TextRecognizer _recognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  Future<String> extractText(File imageFile) async {
    // Step 1 — Image process
    final processedFile = await _preprocessImage(imageFile);

    // Step 2 — Provide MLKIt
    final inputImage = InputImage.fromFile(processedFile);
    final recognized = await _recognizer.processImage(inputImage);

    return recognized.text;
  }

  Future<File> _preprocessImage(File imageFile) async {
    // Import the image package to manipulate the image
    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) return imageFile;

    // Step 1 — Resize
    if (image.width > 2000 || image.height > 2000) {
      image = img.copyResize(
        image,
        width: 2000,
        maintainAspect: true,
      );
    }

    // Step 2 — Grayscale 
    image = img.grayscale(image);

    // Step 3 — Contrast increase
    image = img.adjustColor(
      image,
      contrast: 1.5,  // 1.0 = normal, 1.5 = more contrast
    );

    // Step 4 — Sharpen 
    image = img.convolution(
      image,
      filter: [0, -1, 0, -1, 5, -1, 0, -1, 0],
      div: 1,
    );

    // Step 5 — Save the processed image to a temporary file
    final tempDir = await getTemporaryDirectory();
    final processedPath = '${tempDir.path}/processed_ocr.jpg';
    final processedFile = File(processedPath);
    await processedFile.writeAsBytes(img.encodeJpg(image, quality: 95));

    return processedFile;
  }

  void dispose() {
    _recognizer.close();
  }
}
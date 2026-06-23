import 'dart:io';
import '../core/services/ocr_service.dart';
class OcrRepository {
  
  final OcrService _ocrService;
  OcrRepository(this._ocrService);

Future<String> extractText(File imageFile) async{
  try{
  final text = await _ocrService.extractText(imageFile);
  if(text.trim().isEmpty){
    throw Exception('No text found in the image.');
  }
  return text.trim();
  
  }catch(e){
    throw Exception('OCR error: $e');
  }
}
void dispose() {
  _ocrService.dispose();

}
}
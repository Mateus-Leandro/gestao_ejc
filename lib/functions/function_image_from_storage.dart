import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FunctionImageFromStorage extends StatefulWidget {
  final String imagePath;

  const FunctionImageFromStorage({
    super.key,
    required this.imagePath,
  });

  @override
  _FunctionImageFromStorageState createState() => _FunctionImageFromStorageState();
}

class _FunctionImageFromStorageState extends State<FunctionImageFromStorage> {
  String? _imageUrl;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final Reference ref =
          FirebaseStorage.instance.ref().child(widget.imagePath);
      final String url = await ref.getDownloadURL();
      if(mounted){
        setState(() {
          _imageUrl = url;
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (e) {
      print("Erro ao carregar a imagem: $e");
      if(mounted){
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return const Center(
        child: Text("Erro ao carregar a imagem."),
      );
    }

    return Image.network(
      _imageUrl!,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes!)
                  : null,
            ),
          );
        }
      },
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  }
}

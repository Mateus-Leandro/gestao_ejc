import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker_web/image_picker_web.dart';

class CustomImagePicker extends StatefulWidget {
  final String messageTooltip;
  final Uint8List? actualImage;
  final ValueChanged<Uint8List?> onImageSelected;
  final bool isDisabled;

  const CustomImagePicker({
    super.key,
    required this.messageTooltip,
    this.actualImage,
    required this.onImageSelected,
    required this.isDisabled,
  });

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  Uint8List? selectedImage;

  @override
  void initState() {
    super.initState();
    selectedImage = widget.actualImage;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          message: widget.isDisabled ? '' : widget.messageTooltip,
          child: selectedImage == null
              ? IconButton(
            onPressed: widget.isDisabled ? null : _pickImage,
            icon: FaIcon(
              FontAwesomeIcons.image,
              size: 180,
              color: widget.isDisabled ? Colors.grey : null,
            ),
          )
              : Stack(
            alignment: Alignment.topRight, // Alinha o "X" no canto superior direito
            children: [
              GestureDetector(
                onTap: widget.isDisabled ? null : _pickImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Opacity(
                    opacity: widget.isDisabled ? 0.5 : 1.0, // Ajusta a opacidade
                    child: Image.memory(
                      selectedImage!,
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              if (!widget.isDisabled)
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: _removeImage,
                  tooltip: 'Remover Imagem',
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _pickImage() async {
    if (widget.isDisabled) return;

    final image = await ImagePickerWeb.getImageAsBytes();
    if (image != null) {
      setState(() {
        selectedImage = image;
        widget.onImageSelected(selectedImage);
      });
    }
  }

  void _removeImage() {
    if (widget.isDisabled) return;

    setState(() {
      selectedImage = null;
      widget.onImageSelected(null);
    });
  }
}

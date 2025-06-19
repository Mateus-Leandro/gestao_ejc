import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_delete_button.dart';
import 'package:gestao_ejc/components/buttons/custom_edit_button.dart';
import 'package:gestao_ejc/components/forms/custom_speaker_form.dart';
import 'package:gestao_ejc/components/utils/custom_list_tile.dart';
import 'package:gestao_ejc/components/utils/custom_search_row.dart';
import 'package:gestao_ejc/controllers/lecture_controller.dart';
import 'package:gestao_ejc/controllers/speaker_controller.dart';
import 'package:gestao_ejc/models/lecture_model.dart';
import 'package:gestao_ejc/models/speaker_couple_model.dart';
import 'package:gestao_ejc/models/speaker_model.dart';
import 'package:gestao_ejc/screens/model_screen.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:intl/intl.dart';

class SpeakerScreen extends StatefulWidget {
  const SpeakerScreen({super.key});

  @override
  State<SpeakerScreen> createState() => _SpeakerScreenState();
}

class _SpeakerScreenState extends State<SpeakerScreen> {
  final TextEditingController _speakerNameController = TextEditingController();
  final SpeakerController _speakerController = getIt<SpeakerController>();
  final LectureController _lectureController = getIt<LectureController>();
  bool loadingSpeakers = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _speakerController.init();
  }

  @override
  void dispose() {
    _speakerNameController.dispose();
    _speakerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModelScreen(
      title: 'Palestrantes',
      body: Column(
        children: [
          CustomSearchRow(
            messageButton: 'Incluir Palestrante',
            functionButton: () => _showSpeakerForm(null),
            showButton: true,
            inputType: TextInputType.text,
            controller: _speakerNameController,
            messageTextField: 'Pesquisar palestrante',
            functionTextField: () => setState(() {}),
            iconButton: const Icon(Icons.add),
          ),
          Expanded(child: _buildSpeakersList(context)),
        ],
      ),
      indexMenuSelected: 6,
      showMenuDrawer: true,
    );
  }

  void _showSpeakerForm(AbstractSpeakerModel? speaker) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomSpeakerForm(
          editingSpeaker: speaker,
        );
      },
    );
  }

  Future<bool> _showDeleteConfirmationDialog(
      AbstractSpeakerModel speaker) async {
    bool hasLectures = await _speakerController.speakerHasLectures(speaker.id);
    String message = hasLectures
        ? 'Este palestrante está associado a palestras. Ao excluir, ele será removido das palestras. Deseja continuar?'
        : 'Deseja realmente excluir este palestrante?';

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar Exclusão'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('Excluir'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _showSpeakerLectures(AbstractSpeakerModel speaker) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      List<LectureModel> lectures =
          await _speakerController.getSpeakerLectures(speaker.id);

      Navigator.of(context).pop();

      if (lectures.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Palestras'),
              content: const Text(
                  'Este palestrante não possui palestras cadastradas.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Diálogo de palestras com responsividade melhorada
        final Size screenSize = MediaQuery.of(context).size;
        final double dialogWidth =
            screenSize.width > 600 ? 500 : screenSize.width * 0.9;
        final double dialogHeight =
            screenSize.height > 800 ? 600 : screenSize.height * 0.7;

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: dialogWidth,
                  maxHeight: dialogHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Palestras do Palestrante',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: lectures.length,
                          itemBuilder: (context, index) {
                            var lecture = lectures[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lecture.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Encontro: ${lecture.sequentialEncounter}',
                                    ),
                                    Text(
                                      'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(lecture.startTime.toDate())}',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Fechar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      CustomSnackBar.show(
        context: context,
        message: 'Erro ao buscar palestras: $e',
        colorBar: Colors.red,
      );
    }
  }

  Future<void> _deleteSpeaker(AbstractSpeakerModel speaker) async {
    if (_isDeleting) return;

    bool confirmDelete = await _showDeleteConfirmationDialog(speaker);
    if (!confirmDelete) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      await _speakerController.deleteSpeaker(speaker: speaker);

      CustomSnackBar.show(
        context: context,
        message: 'Palestrante excluído com sucesso!',
        colorBar: Colors.green,
      );
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: 'Erro ao excluir palestrante: $e',
        colorBar: Colors.red,
      );
    } finally {
      setState(() {
        _isDeleting = false;
      });
    }
  }

  Widget _buildSpeakersList(BuildContext context) {
    return StreamBuilder(
        stream: _speakerController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar palestrantes: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum palestrante encontrado'));
          }

          var speakers = snapshot.data!;

          if (_speakerNameController.text.isNotEmpty) {
            final query = _speakerNameController.text.toLowerCase();
            speakers = speakers
                .where((speaker) => speaker.name.toLowerCase().contains(query))
                .toList();
          }

          return ListView.builder(
            itemCount: speakers.length,
            itemBuilder: (context, index) {
              var speaker = speakers[index];
              return _buildSpeakerTile(
                context,
                speaker,
              );
            },
          );
        });
  }

  Widget _buildSpeakerTile(BuildContext context, AbstractSpeakerModel speaker) {
    // Verificamos a largura da tela para decidir o layout
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;

    if (speaker is SpeakerCoupleModel) {
      var uncle = speaker.uncle;
      var aunt = speaker.aunt;

      return CustomListTile(
        listTile: isSmallScreen
            ? _buildCompactCoupleTile(speaker, uncle, aunt)
            : _buildRegularCoupleTile(speaker, uncle, aunt),
        defaultBackgroundColor: Colors.white,
      );
    } else {
      SpeakerModel individualSpeaker = speaker as SpeakerModel;
      return CustomListTile(
        listTile: isSmallScreen
            ? _buildCompactSpeakerTile(individualSpeaker)
            : _buildRegularSpeakerTile(individualSpeaker),
        defaultBackgroundColor: Colors.white,
      );
    }
  }

  // Versão compacta para casal em telas pequenas
  ListTile _buildCompactCoupleTile(
      SpeakerCoupleModel speaker, dynamic uncle, dynamic aunt) {
    return ListTile(
      leading: SizedBox(
        width: 60,
        child: Stack(
          children: [
            CircleAvatar(
              backgroundImage:
                  uncle.urlImage != null && uncle.urlImage!.isNotEmpty
                      ? NetworkImage(uncle.urlImage!)
                      : null,
              child: uncle.urlImage == null || uncle.urlImage!.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
            Positioned(
              left: 20,
              child: CircleAvatar(
                backgroundImage:
                    aunt.urlImage != null && aunt.urlImage!.isNotEmpty
                        ? NetworkImage(aunt.urlImage!)
                        : null,
                child: aunt.urlImage == null || aunt.urlImage!.isEmpty
                    ? const Icon(Icons.person)
                    : null,
              ),
            ),
          ],
        ),
      ),
      title: Text(
        speaker.name,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tio: ${uncle.phone ?? 'Sem telefone'}',
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Tia: ${aunt.phone ?? 'Sem telefone'}',
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: _buildPopupMenu(speaker),
      isThreeLine: true,
    );
  }

  // Versão regular para casal em telas maiores
  ListTile _buildRegularCoupleTile(
      SpeakerCoupleModel speaker, dynamic uncle, dynamic aunt) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage:
                uncle.urlImage != null && uncle.urlImage!.isNotEmpty
                    ? NetworkImage(uncle.urlImage!)
                    : null,
            child: uncle.urlImage == null || uncle.urlImage!.isEmpty
                ? const Icon(Icons.person)
                : null,
          ),
          const SizedBox(width: 4),
          CircleAvatar(
            backgroundImage: aunt.urlImage != null && aunt.urlImage!.isNotEmpty
                ? NetworkImage(aunt.urlImage!)
                : null,
            child: aunt.urlImage == null || aunt.urlImage!.isEmpty
                ? const Icon(Icons.person)
                : null,
          ),
        ],
      ),
      title: Text(speaker.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tio: ${uncle.phone ?? 'Sem telefone'}'),
          Text('Tia: ${aunt.phone ?? 'Sem telefone'}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.event_note, color: Colors.blue),
            tooltip: 'Ver Palestras',
            onPressed: () => _showSpeakerLectures(speaker),
          ),
          CustomEditButton(
            form: CustomSpeakerForm(
              editingSpeaker: speaker,
            ),
          ),
          CustomDeleteButton(
            deleteFunction: () => _deleteSpeaker(speaker),
            alertMessage: 'Excluir palestrante?',
            iconButton: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
          ),
        ],
      ),
      isThreeLine: true,
    );
  }

  // Versão compacta para palestrante individual em telas pequenas
  ListTile _buildCompactSpeakerTile(SpeakerModel speaker) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            speaker.urlImage != null && speaker.urlImage!.isNotEmpty
                ? NetworkImage(speaker.urlImage!)
                : null,
        child: speaker.urlImage == null || speaker.urlImage!.isEmpty
            ? const Icon(Icons.person)
            : null,
      ),
      title: Text(
        speaker.name,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        speaker.phone ?? 'Sem telefone',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: _buildPopupMenu(speaker),
    );
  }

  // Versão regular para palestrante individual em telas maiores
  ListTile _buildRegularSpeakerTile(SpeakerModel speaker) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            speaker.urlImage != null && speaker.urlImage!.isNotEmpty
                ? NetworkImage(speaker.urlImage!)
                : null,
        child: speaker.urlImage == null || speaker.urlImage!.isEmpty
            ? const Icon(Icons.person)
            : null,
      ),
      title: Text(speaker.name),
      subtitle: Text(speaker.phone ?? 'Sem telefone'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.event_note, color: Colors.blue),
            tooltip: 'Ver Palestras',
            onPressed: () => _showSpeakerLectures(speaker),
          ),
          CustomEditButton(
            form: CustomSpeakerForm(
              editingSpeaker: speaker,
            ),
          ),
          CustomDeleteButton(
            deleteFunction: () => _deleteSpeaker(speaker),
            alertMessage: 'Excluir palestrante?',
            iconButton: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // Menu popup para telas pequenas
  Widget _buildPopupMenu(AbstractSpeakerModel speaker) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (String value) {
        switch (value) {
          case 'lectures':
            _showSpeakerLectures(speaker);
            break;
          case 'edit':
            _showSpeakerForm(speaker);
            break;
          case 'delete':
            _deleteSpeaker(speaker);
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'lectures',
          child: Row(
            children: [
              Icon(Icons.event_note, color: Colors.blue),
              SizedBox(width: 8),
              Text('Ver Palestras'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.orange),
              SizedBox(width: 8),
              Text('Editar'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_forever, color: Colors.red),
              SizedBox(width: 8),
              Text('Excluir'),
            ],
          ),
        ),
      ],
    );
  }
}

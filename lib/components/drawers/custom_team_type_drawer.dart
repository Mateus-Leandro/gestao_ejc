import 'package:flutter/material.dart';
import 'package:gestao_ejc/enums/team_type_enum.dart';

class CustomTeamTypeDrawer extends StatefulWidget {
  final TeamTypeEnum? initialTeamType;
  final ValueChanged<TeamTypeEnum> teamTypeSelected;
  final String tooltipMessage;
  final bool allowSelection;

  const CustomTeamTypeDrawer({
    Key? key,
    required this.initialTeamType,
    required this.teamTypeSelected,
    required this.tooltipMessage,
    required this.allowSelection,
  }) : super(key: key);

  @override
  State<CustomTeamTypeDrawer> createState() => _CustomTeamTypeDrawerState();
}

class _CustomTeamTypeDrawerState extends State<CustomTeamTypeDrawer> {
  late TeamTypeEnum? _currentTeamType;

  @override
  void initState() {
    super.initState();
    _currentTeamType = widget.initialTeamType;
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltipMessage,
      child: DropdownButton<TeamTypeEnum>(
        focusColor: Colors.transparent,
        value: _currentTeamType,
        icon: const Icon(Icons.arrow_drop_down),
        items: TeamTypeEnum.values.map((TeamTypeEnum team) {
          return DropdownMenuItem<TeamTypeEnum>(
            value: team,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: team.teamIcon,
                ),
                Text(team.formattedName),
              ],
            ),
          );
        }).toList(),
        onChanged: widget.allowSelection
            ? (teamType) {
                if (teamType != null) {
                  setState(() {
                    _currentTeamType = teamType;
                  });
                  widget.teamTypeSelected(teamType);
                }
              }
            : null,
      ),
    );
  }
}

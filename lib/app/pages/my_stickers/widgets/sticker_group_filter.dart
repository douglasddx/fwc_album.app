import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:fwc_album_app/app/core/ui/styles/text_styles.dart';
import 'package:fwc_album_app/app/pages/my_stickers/presenter/my_stickers_presenter.dart';

class StickerGroupFilter extends StatefulWidget {
  final Map<String, String> countries;
  const StickerGroupFilter({
    super.key,
    required this.countries,
  });

  @override
  State<StickerGroupFilter> createState() => _StickerGroupFilterState();
}

class _StickerGroupFilterState extends State<StickerGroupFilter> {
  List<String>? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SmartSelect<String>.multiple(
        tileBuilder: (context, state) {
          return InkWell(
            onTap: state.showModal,
            child: _StickerGroupTile(
              label: state.selected.title?.join(', ') ?? 'Filtro',
              clearCallback: (() {
                setState(() {
                  selectedValue = null;
                  context
                      .get<MyStrickersPresenter>()
                      .countryFilter(selectedValue);
                });
              }),
            ),
          );
        },
        title: 'Filtro',
        selectedValue: selectedValue ?? [],
        onChange: (selected) => {
          setState(() {
            selectedValue = selected.value;
          }),
          context.get<MyStrickersPresenter>().countryFilter(selectedValue),
        },
        choiceItems: S2Choice.listFrom(
          source: widget.countries.entries
              .map(
                (e) => {'value': e.key, 'title': e.value},
              )
              .toList(),
          value: (index, item) => item['value'] ?? '',
          title: (index, item) => item['title'] ?? '',
        ),
        choiceType: S2ChoiceType.switches,
        modalType: S2ModalType.bottomSheet,
        choiceGrouped: true,
        modalFilter: false,
        placeholder: '',
      ),
    );
  }
}

class _StickerGroupTile extends StatelessWidget {
  final String label;
  final VoidCallback clearCallback;

  const _StickerGroupTile({
    Key? key,
    required this.label,
    required this.clearCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0XFFF0F0F0),
        borderRadius: BorderRadius.circular(20),
      ),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            const Icon(Icons.filter_list),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                label,
                style: TextStyles.i.textSecondaryFontRegular.copyWith(
                  fontSize: 11,
                ),
              ),
            ),
            InkWell(
              onTap: clearCallback,
              child: const Icon(Icons.clear),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:app_creaty/commons/extensions/json_widget/cross_axis_alignment_extension.dart';
import 'package:app_creaty/commons/extensions/json_widget/json_widget_extension.dart';
import 'package:app_creaty/commons/extensions/json_widget/main_axis_alignment_extension.dart';
import 'package:app_creaty/commons/extensions/json_widget/main_axis_size_extension.dart';
import 'package:app_creaty/commons/extensions/theme_extension.dart';
import 'package:app_creaty/commons/gen/assets.gen.dart';
import 'package:app_creaty/l10n/l10n.dart';
import 'package:app_creaty/presentation/prop_panel/widgets/widgets.dart';
import 'package:app_creaty/presentation/virtual_app/virtual_app.dart';
import 'package:app_creaty/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:json_widget/json_widget.dart' as json_widget;
import 'package:recase/recase.dart';

class RowPropsPanel extends StatefulWidget {
  const RowPropsPanel({super.key, required this.jsonWidget});

  final json_widget.Row jsonWidget;

  @override
  State<RowPropsPanel> createState() => _RowPropsPanelState();
}

class _RowPropsPanelState extends State<RowPropsPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Row',
              style: context.textTheme.displayMedium,
            ),
            const Gap(16),
            IconButton(
              icon: Assets.icons.other.trash.svg(),
              onPressed: () {
                context
                    .read<VirtualAppBloc>()
                    .add(DeleteWidget(widget: widget.jsonWidget));
              },
            ),
          ],
        ),
        const Gap(32),
        ColumnWithSpacing(
          spacing: 24,
          children: [
            _buildMainAxisSizeProp(),
            _buildCrossAxisAlignmentProp(),
            _buildMainAxisAlignmentProp(),
            _buildChildrenList(),
          ],
        )
      ],
    );
  }

  Widget _buildMainAxisSizeProp() {
    return FieldPropTile(
      titleText: context.l10n.mainAxisSizeLabel,
      child: Row(
        children: json_widget.MainAxisSize.values.map((value) {
          return PropIconButton(
            icon: value.image,
            tooltip: value.getTooltip(context),
            isSelected: value == widget.jsonWidget.mainAxisSize,
            onPressed: () {
              final updatedRow =
                  widget.jsonWidget.copyWith(mainAxisSize: value);
              context
                  .read<VirtualAppBloc>()
                  .add(ChangeProp(widget: updatedRow));
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCrossAxisAlignmentProp() {
    final crossProps = List.of(json_widget.CrossAxisAlignment.values)
      ..remove(json_widget.CrossAxisAlignment.baseline);
    return FieldPropTile(
      titleText: context.l10n.crossAxisAlignmentLabel,
      child: Row(
        children: crossProps.map((value) {
          return PropIconButton(
            icon: value.getSvgImage(isColumn: false),
            tooltip: value.getTooltip(context),
            isSelected: value == widget.jsonWidget.crossAxisAlignment,
            onPressed: () {
              final updatedRow =
                  widget.jsonWidget.copyWith(crossAxisAlignment: value);
              context
                  .read<VirtualAppBloc>()
                  .add(ChangeProp(widget: updatedRow));
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMainAxisAlignmentProp() {
    return FieldPropTile(
      titleText: context.l10n.mainAxisAligmentLabel,
      child: Row(
        children: json_widget.MainAxisAlignment.values.map((value) {
          return PropIconButton(
            icon: value.getSvgImage(isColumn: false),
            tooltip: value.getTooltip(context),
            isSelected: value == widget.jsonWidget.mainAxisAlignment,
            onPressed: () {
              final updatedRow =
                  widget.jsonWidget.copyWith(mainAxisAlignment: value);
              context
                  .read<VirtualAppBloc>()
                  .add(ChangeProp(widget: updatedRow));
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChildrenList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.childrenLabel,
          style: context.textTheme.titleMedium,
        ),
        const Gap(16),
        ReorderableListView.builder(
          shrinkWrap: true,
          buildDefaultDragHandles: false,
          itemCount: widget.jsonWidget.children.length,
          itemBuilder: (context, index) {
            final child = widget.jsonWidget.children[index];
            return ListTile(
              onTap: () => context
                  .read<VirtualAppBloc>()
                  .add(PreviewWidget(selectedWidget: child)),
              onLongPress: () => context
                  .read<VirtualAppBloc>()
                  .add(ChangeWidget(selectedWidget: child)),
              key: ValueKey(child.key.toString()),
              leading: ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle),
              ),
              title: Text(child.runtimeTypeValue.pascalCase),
            );
          },
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
            });
            final children = List.of(widget.jsonWidget.children);
            final item = children.removeAt(oldIndex);
            children.insert(newIndex, item);
            final updatedRow = widget.jsonWidget.copyWith(children: children);
            context.read<VirtualAppBloc>().add(ChangeProp(widget: updatedRow));
          },
        ),
      ],
    );
  }
}

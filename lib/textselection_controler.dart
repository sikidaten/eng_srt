import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomMenuPage extends StatefulWidget {
  const CustomMenuPage({Key? key}) : super(key: key);

  static const String routeName = '/custom-menu';

  @override
  _CustomMenuPageState createState() => _CustomMenuPageState();
}

class _CustomMenuPageState extends State<CustomMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // title: 'Custom Menu Page',
      /*
      child: TextField(
        maxLines: 5,
        selectionControls: MyMaterialTextSelectionControls(),
      ),
      */
      body: Center(
        child: SelectableText(
          'Select me custom menu',
          selectionControls: MyMaterialTextSelectionControls(),
        ),
      ),
    );
  }
}

class MyMaterialTextSelectionControls extends MaterialTextSelectionControls {
  // Padding between the toolbar and the anchor.
  static const double _kToolbarContentDistanceBelow = 20.0;
  static const double _kToolbarContentDistance = 8.0;

  /// Builder for material-style copy/paste text selection toolbar.
  @override
  Widget buildToolbar(
      BuildContext context,
      Rect globalEditableRegion,
      double textLineHeight,
      Offset selectionMidpoint,
      List<TextSelectionPoint> endpoints,
      TextSelectionDelegate delegate,
      ClipboardStatusNotifier? clipboardStatus,
      Offset? ofset) {
    final TextSelectionPoint startTextSelectionPoint = endpoints[0];
    final TextSelectionPoint endTextSelectionPoint =
        endpoints.length > 1 ? endpoints[1] : endpoints[0];
    final Offset anchorAbove = Offset(
        globalEditableRegion.left + selectionMidpoint.dx,
        globalEditableRegion.top +
            startTextSelectionPoint.point.dy -
            textLineHeight -
            _kToolbarContentDistance);
    final Offset anchorBelow = Offset(
      globalEditableRegion.left + selectionMidpoint.dx,
      globalEditableRegion.top + endTextSelectionPoint.point.dy + _kToolbarContentDistanceBelow,
    );

    return MyTextSelectionToolbar(
      anchorAbove: anchorAbove,
      anchorBelow: anchorBelow,
      clipboardStatus: clipboardStatus!,
      handleCopy: canCopy(delegate) && handleCopy != null
          ? () => handleCopy(delegate, clipboardStatus)
          : null,
      handleopendictButton: () {
        // var selected = delegate.textEditingValue.copyWith(
        //   selection: TextSelection.collapsed(
        //     offset: delegate.textEditingValue.selection.baseOffset,
        //   ),
        // );
        String selected=delegate.textEditingValue.text.substring(
            delegate.textEditingValue.selection.baseOffset,
            delegate.textEditingValue.selection.extentOffset).toLowerCase();
        delegate.hideToolbar();
        launch("https://www.oxfordlearnersdictionaries.com/definition/english/${selected}");
      },
      handleopendeeplButton: (){
        String selected=delegate.textEditingValue.text.substring(
            delegate.textEditingValue.selection.baseOffset,
            delegate.textEditingValue.selection.extentOffset);
        delegate.hideToolbar();
        launch("https://www.deepl.com/ja/translator#en/ja/${selected}");
      },
      handleCut: canCut(delegate) && handleCut != null ? () => handleCut(delegate, null) : null,
      handlePaste: canPaste(delegate) && handlePaste != null ? () => handlePaste(delegate) : null,
      handleSelectAll: canSelectAll(delegate) && handleSelectAll != null
          ? () => handleSelectAll(delegate)
          : null,
    );
  }
}

class MyTextSelectionToolbar extends StatefulWidget {
  const MyTextSelectionToolbar({
    Key? key,
    required this.anchorAbove,
    required this.anchorBelow,
    required this.clipboardStatus,
    this.handleCopy,
    this.handleopendictButton,
    this.handleopendeeplButton,
    this.handleCut,
    this.handlePaste,
    this.handleSelectAll,
  }) : super(key: key);

  final Offset anchorAbove;
  final Offset anchorBelow;
  final ClipboardStatusNotifier clipboardStatus;
  final VoidCallback? handleCopy;
  final VoidCallback? handleopendictButton;
  final VoidCallback? handleopendeeplButton;
  final VoidCallback? handleCut;
  final VoidCallback? handlePaste;
  final VoidCallback? handleSelectAll;

  @override
  MyTextSelectionToolbarState createState() => MyTextSelectionToolbarState();
}

class MyTextSelectionToolbarState extends State<MyTextSelectionToolbar> {
  void _onChangedClipboardStatus() {
    setState(() {
      // Inform the widget that the value of clipboardStatus has changed.
    });
  }

  @override
  void initState() {
    super.initState();
    widget.clipboardStatus.addListener(_onChangedClipboardStatus);
    widget.clipboardStatus.update();
  }

  @override
  void didUpdateWidget(MyTextSelectionToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clipboardStatus != oldWidget.clipboardStatus) {
      widget.clipboardStatus.addListener(_onChangedClipboardStatus);
      oldWidget.clipboardStatus.removeListener(_onChangedClipboardStatus);
    }
    widget.clipboardStatus.update();
  }

  @override
  void dispose() {
    super.dispose();
    if (!widget.clipboardStatus.disposed) {
      widget.clipboardStatus.removeListener(_onChangedClipboardStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return TextSelectionToolbar(
      anchorAbove: widget.anchorAbove,
      anchorBelow: widget.anchorBelow,
      toolbarBuilder: (BuildContext context, Widget child) {
        return Container(
          color: Colors.white,
          child: child,
        );
      },
      children: <Widget>[
        // if (widget.handleCut != null)
        //   TextSelectionToolbarTextButton(
        //     TODO(justinmc): Position not necessarily correct. Use a List.
        // padding: EdgeInsets.zero,
        // onPressed: widget.handleCut,
        // child: Text(localizations.cutButtonLabel),
        // ),
        if (widget.handleCopy != null)
          TextSelectionToolbarTextButton(
            padding: EdgeInsets.zero,
            onPressed: widget.handleCopy,
            child: Icon(Icons.copy),
          ),
        // if (widget.handlePaste != null &&
        //     widget.clipboardStatus.value == ClipboardStatus.pasteable)
        //   TextSelectionToolbarTextButton(
        //     padding: EdgeInsets.zero,
        //     onPressed: widget.handlePaste,
        //     child: Text(localizations.pasteButtonLabel),
        //   ),
        // if (widget.handleSelectAll != null)
        //   TextSelectionToolbarTextButton(
        //     padding: EdgeInsets.zero,
        //     onPressed: widget.handleSelectAll,
        //     child: Text(localizations.selectAllButtonLabel),
        //   ),
        TextSelectionToolbarTextButton(
          onPressed: widget.handleopendictButton,
          padding: EdgeInsets.zero,
          child: Icon(Icons.description),
        ),
        TextSelectionToolbarTextButton(
          onPressed: widget.handleopendeeplButton,
          padding: EdgeInsets.zero,
          child: Icon(Icons.translate),
        ),
      ],
    );
  }
}

void main() {
  return runApp(MaterialApp(
    home: CustomMenuPage(),
  ));
}

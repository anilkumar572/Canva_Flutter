import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController _textController = TextEditingController();
  Offset _currentPosition = Offset(100, 100);
  List<Offset> undoStack = [];
  List<Offset> redoStack = [];
  String _selectedFont = 'Roboto';
  double _fontSize = 18;
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  String displayedText = '';

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      undoStack.add(_currentPosition);
      redoStack.clear();
      final deltaDx = details.localPosition.dx - _currentPosition.dx;
      final deltaDy = details.localPosition.dy - _currentPosition.dy;

      final newDx = _currentPosition.dx + deltaDx;
      final newDy = _currentPosition.dy + deltaDy;

      final double maxDx = 350 - 100;
      final double maxDy = 500 - 30;

      _currentPosition = Offset(
        newDx.clamp(0.0, maxDx),
        newDy.clamp(0.0, maxDy),
      );
    });
  }

  void _undo() {
    if (undoStack.isNotEmpty) {
      setState(() {
        redoStack.add(_currentPosition);
        _currentPosition = undoStack.removeLast();
      });
    }
  }

  void _redo() {
    if (redoStack.isNotEmpty) {
      setState(() {
        undoStack.add(_currentPosition);
        _currentPosition = redoStack.removeLast();
      });
    }
  }

  TextStyle _getTextStyle() {
    return TextStyle(
      fontSize: _fontSize,
      fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: _isUnderline ? TextDecoration.underline : TextDecoration.none,
      fontFamily: _selectedFont,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: _undo,
                      borderRadius: BorderRadius.circular(5),
                      child: const Icon(
                        Icons.undo,
                        size: 30,
                      ),
                    ),
                    const Text(
                      "Undo",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(width: 80),
                Column(
                  children: [
                    InkWell(
                      onTap: _redo,
                      borderRadius: BorderRadius.circular(5),
                      child: const Icon(
                        Icons.redo,
                        size: 30,
                      ),
                    ),
                    const Text(
                      "Redo",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onPanUpdate: _onDragUpdate,
              child: Container(
                margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
                width: 350,
                height: 500,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: _currentPosition.dx,
                      top: _currentPosition.dy,
                      child: Text(
                        displayedText,
                        style: _getTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 40,
              child: TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: "Enter Text",
                  labelText: "Text",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  displayedText = _textController.text;
                });
              },
              child: const Text("Add"),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                DropdownButton<String>(
                  value: _selectedFont,
                  items: ['Roboto', 'Arial', 'Times New Roman'].map((font) {
                    return DropdownMenuItem(
                      value: font,
                      child: Text(font),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFont = value!;
                    });
                  },
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          _fontSize =
                              (_fontSize > 10) ? _fontSize - 1 : _fontSize;
                        });
                      },
                    ),
                    Text(_fontSize.toInt().toString()),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _fontSize += 1;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          setState(() {
                            _isBold = !_isBold;
                          });
                        },
                        child: const Text(
                          "B",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          setState(() {
                            _isItalic = !_isItalic;
                          });
                        },
                        child: const Text("I",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(2),
                        onTap: () {
                          setState(() {
                            _isUnderline = !_isUnderline;
                          });
                        },
                        child: const Text("U",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

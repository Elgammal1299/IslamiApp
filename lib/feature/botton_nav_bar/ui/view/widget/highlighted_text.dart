import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle baseStyle;
  final TextStyle highlightStyle;
  final bool caseSensitive;

  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    required this.baseStyle,
    required this.highlightStyle,
    this.caseSensitive = false,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text, style: baseStyle);
    }

    final searchText = caseSensitive ? query : query.toLowerCase();
    final displayText = caseSensitive ? text : text.toLowerCase();

    final List<TextSpan> spans = [];
    int lastIndex = 0;

    // Find all occurrences of the query
    int index = 0;
    while (index <= displayText.length - searchText.length) {
      index = displayText.indexOf(searchText, lastIndex);

      if (index == -1) {
        // No more matches found
        if (lastIndex < text.length) {
          spans.add(
            TextSpan(text: text.substring(lastIndex), style: baseStyle),
          );
        }
        break;
      }

      // Add text before the match
      if (index > lastIndex) {
        spans.add(
          TextSpan(text: text.substring(lastIndex, index), style: baseStyle),
        );
      }

      // Add the highlighted match
      spans.add(
        TextSpan(
          text: text.substring(index, index + searchText.length),
          style: highlightStyle,
        ),
      );

      lastIndex = index + searchText.length;
      index = lastIndex;
    }

    return RichText(
      text: TextSpan(
        children:
            spans.isEmpty ? [TextSpan(text: text, style: baseStyle)] : spans,
      ),
    );
  }
}

// Helper function to easily use highlighted text
class SearchHighlighter {
  static TextSpan highlightSpan({
    required String text,
    required String query,
    required TextStyle baseStyle,
    required TextStyle highlightStyle,
    bool caseSensitive = false,
  }) {
    if (query.isEmpty) {
      return TextSpan(text: text, style: baseStyle);
    }

    final searchText = caseSensitive ? query : query.toLowerCase();
    final displayText = caseSensitive ? text : text.toLowerCase();

    final List<TextSpan> spans = [];
    int lastIndex = 0;

    int index = 0;
    while (index <= displayText.length - searchText.length) {
      index = displayText.indexOf(searchText, lastIndex);

      if (index == -1) {
        if (lastIndex < text.length) {
          spans.add(
            TextSpan(text: text.substring(lastIndex), style: baseStyle),
          );
        }
        break;
      }

      if (index > lastIndex) {
        spans.add(
          TextSpan(text: text.substring(lastIndex, index), style: baseStyle),
        );
      }

      spans.add(
        TextSpan(
          text: text.substring(index, index + searchText.length),
          style: highlightStyle,
        ),
      );

      lastIndex = index + searchText.length;
      index = lastIndex;
    }

    return TextSpan(
      children:
          spans.isEmpty ? [TextSpan(text: text, style: baseStyle)] : spans,
    );
  }
}

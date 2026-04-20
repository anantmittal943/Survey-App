import 'package:flutter/material.dart';

void main() {
  runApp(const SurveyApp());
}

class SurveyApp extends StatelessWidget {
  const SurveyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Survey App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: const SurveyFormScreen(),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: Colors.black,
      brightness: brightness,
    ).copyWith(
      primary: isDark ? const Color(0xFFF5F5F5) : const Color(0xFF111111),
      onPrimary: isDark ? const Color(0xFF111111) : Colors.white,
      secondary: isDark ? const Color(0xFFE5E5E5) : const Color(0xFF2A2A2A),
      onSecondary: isDark ? const Color(0xFF111111) : Colors.white,
      surface: isDark ? const Color(0xFF111111) : const Color(0xFFF9F9F9),
      onSurface: isDark ? const Color(0xFFF5F5F5) : const Color(0xFF121212),
      surfaceContainerHighest:
          isDark ? const Color(0xFF1F1F1F) : const Color(0xFFEDEDED),
      outline: isDark ? const Color(0xFF505050) : const Color(0xFFB8B8B8),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          isDark ? const Color(0xFF0C0C0C) : const Color(0xFFF3F3F3),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFFEFEFEF) : const Color(0xFF1B1B1B),
        contentTextStyle: TextStyle(
          color: isDark ? const Color(0xFF161616) : Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.32)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.45)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.45)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class SurveyResponse {
  const SurveyResponse({
    required this.name,
    required this.feedback,
    required this.discoverySource,
    required this.improvements,
    required this.rating,
  });

  final String name;
  final String feedback;
  final String discoverySource;
  final List<String> improvements;
  final double rating;
}

class SurveyFormScreen extends StatefulWidget {
  const SurveyFormScreen({super.key});

  @override
  State<SurveyFormScreen> createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends State<SurveyFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  String? _discoverySource;
  final Set<String> _selectedImprovements = <String>{};
  double _rating = 4;
  bool _isSubmitting = false;

  static const List<String> _discoveryOptions = <String>[
    'Friend or colleague',
    'Social media',
    'Online search',
    'Advertisement',
  ];

  static const List<String> _improvementOptions = <String>[
    'Design consistency',
    'App performance',
    'Feature clarity',
    'Support quality',
    'Pricing transparency',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    if (_discoverySource == null) {
      _showSnackBar('Please select how you discovered us.');
      return;
    }

    if (_selectedImprovements.isEmpty) {
      _showSnackBar('Choose at least one area to improve.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 280));
    if (!mounted) {
      return;
    }

    final SurveyResponse response = SurveyResponse(
      name: _nameController.text.trim(),
      feedback: _feedbackController.text.trim(),
      discoverySource: _discoverySource!,
      improvements: _selectedImprovements.toList()..sort(),
      rating: _rating,
    );

    setState(() {
      _isSubmitting = false;
    });

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => SurveySummaryScreen(response: response),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool isCompact = MediaQuery.sizeOf(context).width < 480;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Feedback Survey'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              isCompact ? 16 : 24,
              14,
              isCompact ? 16 : 24,
              28,
            ),
            children: <Widget>[
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Tell us about your experience',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'A quick 1-minute survey to help us improve your next visit.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.78),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _SectionCard(
                title: 'Basic details',
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'e.g. Alex Johnson',
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name.';
                        }
                        if (value.trim().length < 2) {
                          return 'Name is too short.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _feedbackController,
                      minLines: 4,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        labelText: 'Open feedback',
                        hintText: 'Share what you liked and what could be better.',
                        alignLabelWithHint: true,
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Feedback is required.';
                        }
                        if (value.trim().length < 12) {
                          return 'Please write at least 12 characters.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _SectionCard(
                title: 'How did you find us?',
                subtitle: 'Choose one option',
                child: RadioGroup<String>(
                  groupValue: _discoverySource,
                  onChanged: (String? value) {
                    setState(() {
                      _discoverySource = value;
                    });
                  },
                  child: Column(
                    children: _discoveryOptions.map((String option) {
                      return RadioListTile<String>(
                        value: option,
                        title: Text(option),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(vertical: -1),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _SectionCard(
                title: 'Where should we improve?',
                subtitle: 'Select all that apply',
                child: Column(
                  children: _improvementOptions.map((String option) {
                    final bool selected = _selectedImprovements.contains(option);
                    return CheckboxListTile(
                      value: selected,
                      title: Text(option),
                      contentPadding: EdgeInsets.zero,
                      visualDensity: const VisualDensity(vertical: -1),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value ?? false) {
                            _selectedImprovements.add(option);
                          } else {
                            _selectedImprovements.remove(option);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),
              _SectionCard(
                title: 'Overall rating',
                subtitle: 'How would you rate your experience?',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: List<Widget>.generate(5, (int index) {
                        final int starNumber = index + 1;
                        final bool filled = _rating >= starNumber;
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              _rating = starNumber.toDouble();
                            });
                          },
                          icon: Icon(
                            filled ? Icons.star_rounded : Icons.star_outline_rounded,
                          ),
                          color: scheme.primary,
                          tooltip: '$starNumber stars',
                        );
                      }),
                    ),
                    Slider(
                      value: _rating,
                      min: 1,
                      max: 5,
                      divisions: 8,
                      label: _rating.toStringAsFixed(1),
                      onChanged: (double value) {
                        setState(() {
                          _rating = value;
                        });
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${_rating.toStringAsFixed(1)} / 5.0',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(_isSubmitting ? 'Submitting...' : 'Submit response'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SurveySummaryScreen extends StatelessWidget {
  const SurveySummaryScreen({super.key, required this.response});

  final SurveyResponse response;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Summary'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: <Widget>[
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Thank you, ${response.name}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your feedback has been captured successfully.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.76),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Your responses',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SummaryRow(label: 'Discovery source', value: response.discoverySource),
                const SizedBox(height: 8),
                _SummaryRow(
                  label: 'Improvement areas',
                  value: response.improvements.join(', '),
                ),
                const SizedBox(height: 8),
                _SummaryRow(
                  label: 'Overall rating',
                  value: '${response.rating.toStringAsFixed(1)} / 5.0',
                ),
                const SizedBox(height: 14),
                Text(
                  'Open feedback',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  response.feedback,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Back to form'),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    this.title,
    this.subtitle,
  });

  final String? title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (title != null) ...<Widget>[
              Text(
                title!,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.73),
                  ),
                ),
              ],
              const SizedBox(height: 12),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyLarge,
        children: <TextSpan>[
          TextSpan(
            text: '$label: ',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.72),
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

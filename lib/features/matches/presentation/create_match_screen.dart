import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:matchup/features/matches/presentation/create_match_controller.dart';
import 'package:matchup/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class CreateMatchScreen extends ConsumerStatefulWidget {
  const CreateMatchScreen({super.key});

  @override
  ConsumerState<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends ConsumerState<CreateMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _venueController = TextEditingController();
  DateTime? _startsAt;

  @override
  void dispose() {
    _venueController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 18, minute: 0),
    );
    if (time == null || !mounted) return;

    setState(() {
      _startsAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submit() async {
    final startsAt = _startsAt;
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;
    if (startsAt == null || !startsAt.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.invalidDateTime)));
      return;
    }

    final created = await ref
        .read(createMatchControllerProvider.notifier)
        .createMatch(
          venueName: _venueController.text.trim(),
          startsAt: startsAt,
        );
    if (created && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final materialL10n = MaterialLocalizations.of(context);
    final isLoading = ref.watch(createMatchControllerProvider).isLoading;

    ref.listen(createMatchControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.genericError)));
      }
    });

    final startsAt = _startsAt;
    final dateText = startsAt == null
        ? l10n.pickDateTime
        : '${materialL10n.formatMediumDate(startsAt)}, '
              '${materialL10n.formatTimeOfDay(TimeOfDay.fromDateTime(startsAt))}';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createMatchTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _venueController,
                      decoration: InputDecoration(labelText: l10n.venue),
                      validator: (value) {
                        final length = (value ?? '').trim().length;
                        return length < 2 || length > 60
                            ? l10n.venueInvalid
                            : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _pickDateTime,
                      icon: const Icon(Icons.event),
                      label: Text(dateText),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.createMatch),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

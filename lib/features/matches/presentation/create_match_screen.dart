import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:matchup/features/matches/domain/match_enums.dart';
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
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  MatchFormat _format = MatchFormat.sets;
  MatchKind _kind = MatchKind.friendly;
  DateTime? _startsAt;

  @override
  void dispose() {
    _venueController.dispose();
    _titleController.dispose();
    _priceController.dispose();
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
          title: _titleController.text.trim(),
          venueName: _venueController.text.trim(),
          format: _format,
          kind: _kind,
          pricePerPlayer: int.parse(_priceController.text),
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
        debugPrint('createMatch error : ${next.error}');
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: l10n.matchTitle),
                      validator: (value) {
                        final length = (value ?? '').trim().length;
                        return length < 3 || length > 40
                            ? l10n.matchTitleInvalid
                            : null;
                      },
                    ),
                    const SizedBox(height: 16),
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
                    Text(
                      l10n.matchFormat,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<MatchFormat>(
                      segments: [
                        ButtonSegment(
                          value: MatchFormat.sets,
                          label: Text(l10n.formatSets),
                        ),
                        ButtonSegment(
                          value: MatchFormat.tournament,
                          label: Text(l10n.formatTournament),
                        ),
                      ],
                      selected: {_format},
                      onSelectionChanged: (selection) =>
                          setState(() => _format = selection.first),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<MatchKind>(
                      segments: [
                        ButtonSegment(
                          value: MatchKind.friendly,
                          label: Text(l10n.kindFriendly),
                        ),
                        ButtonSegment(
                          value: MatchKind.ranked,
                          label: Text(l10n.kindRanked),
                        ),
                      ],
                      selected: {_kind},
                      onSelectionChanged: (selection) =>
                          setState(() => _kind = selection.first),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: l10n.pricePerPlayer,
                      ),
                      validator: (value) {
                        final price = int.tryParse(value ?? '');
                        return price == null || price < 0 || price > 1000
                            ? l10n.priceInvalid
                            : null;
                      },
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

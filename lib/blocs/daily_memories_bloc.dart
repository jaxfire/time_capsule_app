import 'dart:async';

import 'package:time_capsule_app/blocs/bloc_provider.dart';

abstract class DateChangeEvent {
  int changeValue();
}

class DateChangeIncrement extends DateChangeEvent {
  @override
  int changeValue() {
    return 1;
  }
}

class DateChangeDecrement extends DateChangeEvent {
  @override
  int changeValue() {
    return -1;
  }
}

class DayEntry {
  String theDate, entry1, entry2, entry3;
  DayEntry(this.theDate, this.entry1, this.entry2, this.entry3);
}

class DayEntryBloc implements BlocBase {

  ///
  /// Test data
  ///
  List<DayEntry> _dayEntries = List();
  int date = 0;

  // ##########  STREAMS  ##############
  ///
  /// UPSERT day memory entries
  ///
  final _dayEntryAddController = StreamController<String>();
  Sink<String> get inAddDayEntry => _dayEntryAddController.sink; // Input from button handlers


  ///
  /// GET day memory entries
  ///
  final _dayEntryController = StreamController<DayEntry>();
  Sink<DayEntry> get _inDayEntry =>_dayEntryController.sink; // Input from Cloud Firestore
  Stream<DayEntry> get outDayEntry =>_dayEntryController.stream; // Output to whoever subscribes

  ///
  /// CHANGE DATE
  ///
  final _dateChangeController = StreamController<DateChangeEvent>();
  Sink<DateChangeEvent> get inDateChange => _dateChangeController.sink;


  ///
  /// Constructor
  ///
  DayEntryBloc(){

    // Test data
    _dayEntries.add(DayEntry('18/01/2019', 'a','b','c'));
    _dayEntries.add(DayEntry('19/01/2019', 'd','e','f'));
    _dayEntries.add(DayEntry('20/01/2019', 'g','h','i'));

    _dayEntryAddController.stream.listen(_handleAddDayEntry);
    _dateChangeController.stream.listen(_handleDateChange);
  }

  void dispose(){
    _dayEntryAddController.close();
    _dayEntryController.close();
    _dateChangeController.close();
  }

  // ############# HANDLING  #####################

  void _handleAddDayEntry(String inputData){
    print('Handling input: $inputData');
    // Persist the day entry
//    _favorites.add(movieCard);

    _notify();
  }

  void _handleDateChange(DateChangeEvent dateChangeEvent){
    int requestedDate = date + dateChangeEvent.changeValue();
    if(requestedDate >= 0 && requestedDate <= 2) {
      print('Date is in range for test purposes');
      date = requestedDate;
      _inDayEntry.add(_dayEntries[date]);
      // TODO:
      // Check if we already have this date entry in memory.
      // Make request to firebase for new date.
    } else {
      print('Date is out of range');
      // TODO: Disable arrows
    }
  }

  void _notify(){
    // Send to whomever is interested...
  }
}
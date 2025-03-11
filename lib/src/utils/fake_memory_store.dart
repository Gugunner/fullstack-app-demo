import 'package:rxdart/rxdart.dart';

/// A fake memory store that can be used to simulate a memory store.
/// It is useful for storing data from Fake repositories and services. 
class FakeMemoryStore<T> {
  /// Constructor for the FakeMemoryStore class by seeding the store with 
  /// a new seed value.
  FakeMemoryStore(T seed) : _subject = BehaviorSubject.seeded(seed);

  ///The StreamController for the store
  final BehaviorSubject<T> _subject;

  ///The stream getter for the store
  Stream<T> get stream => _subject.stream;
  
  ///The current value of the store
  T get value => _subject.value;

  ///Sets the value of the store
  ///and adds the value to the stream
  set value(T value) => _subject.add(value);

  ///Closes the stream
  void dispose() => _subject.close();
}
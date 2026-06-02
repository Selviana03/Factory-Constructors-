/*
 * TUGAS SESI 10: Factory Constructors
 * Nama  : Serlin Selviana Giay
 * NIM   : 251420030
 * Kelas : SI2A
 */

// --- 1. ConnectionFactory (Pooling) ---
class Connection {
  final String id;
  Connection(this.id);
  void execute(String query) => print("Koneksi $id mengeksekusi: $query");
}

class ConnectionFactory {
  static final List<Connection> _pool = [Connection("DB-1"), Connection("DB-2")];
  static int _index = 0;
  static Connection getConnection() {
    final conn = _pool[_index];
    _index = (_index + 1) % _pool.length;
    return conn;
  }
}

// --- 2. NotificationFactory (Subclass selection) ---
abstract class Notification { void send(String msg); }
class EmailNotification implements Notification { @override void send(String msg) => print("Email: $msg"); }
class PushNotification implements Notification { @override void send(String msg) => print("Push: $msg"); }

class NotificationFactory {
  static Notification create(String platform) {
    if (platform == 'email') return EmailNotification();
    if (platform == 'push') return PushNotification();
    throw Exception("Platform tidak dikenal");
  }
}

// --- 3. ShapeFactory (Caching) ---
class Shape { final String type; Shape(this.type); }
class ShapeFactory {
  static final Map<String, Shape> _cache = {};
  static Shape getShape(String type) => _cache.putIfAbsent(type, () => Shape(type));
}

// --- Challenge: AnimalFactory ---
abstract class Animal { void speak(); }
class Dog implements Animal { @override void speak() => print("Woof!"); }
class Cat implements Animal { @override void speak() => print("Meow!"); }

class AnimalFactory {
  static final Map<String, Animal> _cache = {};
  static Animal createAnimal(String type) {
    if (type.isEmpty) throw ArgumentError("Tipe tidak boleh kosong");
    return _cache.putIfAbsent(type.toLowerCase(), () {
      switch (type.toLowerCase()) {
        case 'dog': return Dog();
        case 'cat': return Cat();
        default: throw Exception("Hewan tidak dikenal");
      }
    });
  }
}

void main() {
  print("--- OUTPUT EKSEKUSI ---");
  ConnectionFactory.getConnection().execute("SELECT * FROM users");
  NotificationFactory.create('email').send('Halo!');
  var s1 = ShapeFactory.getShape('lingkaran');
  var s2 = ShapeFactory.getShape('lingkaran');
  print("Shape Cache sama: ${identical(s1, s2)}");
  AnimalFactory.createAnimal('dog').speak();
}

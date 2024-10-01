class Item {
  int id;
  String name;

  Item({required this.id, required this.name});
}

class ItemManager {
  // Singleton instance
  static final ItemManager _instance = ItemManager._internal();

  // Factory constructor
  factory ItemManager() {
    return _instance;
  }

  // Internal constructor
  ItemManager._internal();

  // In-memory storage for items
  final List<Item> _items = [];
  List<Item> get items => _items;
  // Create
  void createItem(int id, String name) {
    _items.add(Item(id: id, name: name));
    print('Item created: {id: $id, name: $name}');
  }

  // Read all items
  List<Item> getAllItems() {
    return _items;
  }

  // Read a single item by ID
  Item? getItemById(int id) {
    return _items.firstWhere((item) => item.id == id, orElse: () => Item(id: -1, name: ''));
  }

  // Update
  void updateItem(int id, String newName) {
    Item? item = getItemById(id);
    if (item != null) {
      item.name = newName;
      print('Item updated: {id: $id, name: $newName}');
    } else {
      print('Item not found: id $id');
    }
  }

  // Delete
  void deleteItem(int id) {
    Item? item = getItemById(id);
    if (item != null) {
      _items.remove(item);
      print('Item deleted: id $id');
    } else {
      print('Item not found: id $id');
    }
  }
}

void main() {
  // Access the singleton instance
  final itemManager = ItemManager();

  // Create items
  itemManager.createItem(1, 'Item 1');
  itemManager.createItem(2, 'Item 2');

  // Read all items
  List<Item> items = itemManager.getAllItems();
  print('All items: $items');

  // Read a single item by ID
  Item? item = itemManager.getItemById(1);
  print('Item with id 1: $item');

  // Update an item
  itemManager.updateItem(1, 'Updated Item 1');

  // Delete an item
  itemManager.deleteItem(2);

  // Verify deletion
  items = itemManager.getAllItems();
  print('All items after deletion: $items');
}

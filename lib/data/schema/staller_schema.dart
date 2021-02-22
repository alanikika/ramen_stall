const tableStall = "stall";

const id = "id";
const name = "name";
const address = "address";
const latitude = "latitude";
const longitude = "longitude";

const createTableStallSql = """
  CREATE TABLE $tableStall (
    $id INTEGER PRIMARY KEY AUTOINCREMENT,
    $name TEXT,
    $address TEXT,
    $latitude TEXT,
    $longitude TEXT
  )
""";
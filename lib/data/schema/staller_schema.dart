const tableStall = "stall";

const name = "name";
const address = "address";
const latitude = "latitude";
const longitude = "longitude";

const createTableStallSql = """
  CREATE TABLE $tableStall (
    $name TEXT,
    $address TEXT,
    $latitude TEXT,
    $longitude TEXT
  )
""";
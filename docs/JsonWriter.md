## `JsonWriter`

#### `writeStartArray(struct JsonWriter.Json json) → struct JsonWriter.Json` (internal)
Writes the beginning of a JSON array.

#### `writeStartArray(struct JsonWriter.Json json, string propertyName) → struct JsonWriter.Json` (internal)
Writes the beginning of a JSON array with a property name as the key.

#### `writeStartObject(struct JsonWriter.Json json) → struct JsonWriter.Json` (internal)
Writes the beginning of a JSON object.

#### `writeStartObject(struct JsonWriter.Json json, string propertyName) → struct JsonWriter.Json` (internal)
Writes the beginning of a JSON object with a property name as the key.

#### `writeEndArray(struct JsonWriter.Json json) → struct JsonWriter.Json` (internal)
Writes the end of a JSON array.

#### `writeEndObject(struct JsonWriter.Json json) → struct JsonWriter.Json` (internal)
Writes the end of a JSON object.

#### `writeAddressProperty(struct JsonWriter.Json json, string propertyName, address value) → struct JsonWriter.Json` (internal)
Writes the property name and address value (as a JSON string) as part of a name/value pair of a JSON object.

###### `writeAddressValue(struct JsonWriter.Json json, address value) → struct JsonWriter.Json` (internal)
Writes the address value (as a JSON string) as an element of a JSON array.

#### `writeBooleanProperty(struct JsonWriter.Json json, string propertyName, bool value) → struct JsonWriter.Json` (internal)
Writes the property name and boolean value (as a JSON literal "true" or "false") as part of a name/value pair of a JSON object.

#### `writeBooleanValue(struct JsonWriter.Json json, bool value) → struct JsonWriter.Json` (internal)
Writes the boolean value (as a JSON literal "true" or "false") as an element of a JSON array.

#### `writeIntProperty(struct JsonWriter.Json json, string propertyName, int256 value) → struct JsonWriter.Json` (internal)
Writes the property name and int value (as a JSON number) as part of a name/value pair of a JSON object.

#### `writeIntValue(struct JsonWriter.Json json, int256 value) → struct JsonWriter.Json` (internal)
Writes the int value (as a JSON number) as an element of a JSON array.

#### `writeNullProperty(struct JsonWriter.Json json, string propertyName) → struct JsonWriter.Json` (internal)
Writes the property name and value of null as part of a name/value pair of a JSON object.

#### `writeNullValue(struct JsonWriter.Json json) → struct JsonWriter.Json` (internal)
Writes the value of null as an element of a JSON array.

#### `writeStringProperty(struct JsonWriter.Json json, string propertyName, string value) → struct JsonWriter.Json` (internal)
Writes the string text value (as a JSON string) as an element of a JSON array.

#### `writeStringValue(struct JsonWriter.Json json, string value) → struct JsonWriter.Json` (internal)
Writes the property name and string text value (as a JSON string) as part of a name/value pair of a JSON object.

#### `writeUintProperty(struct JsonWriter.Json json, string propertyName, uint256 value) → struct JsonWriter.Json` (internal)
Writes the property name and uint value (as a JSON number) as part of a name/value pair of a JSON object.

#### `writeUintValue(struct JsonWriter.Json json, uint256 value) → struct JsonWriter.Json` (internal)
Writes the uint value (as a JSON number) as an element of a JSON array.
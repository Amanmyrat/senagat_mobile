enum Status { loading, completed, error, none, success }

class StatefulData<T> {
  Status status;
  T? data;
  dynamic error;

  StatefulData.loading() : status = Status.loading;

  StatefulData.completed(this.data) : status = Status.completed;

  StatefulData.error(this.error) : status = Status.error;

  StatefulData.success() : status = Status.success;

  StatefulData.empty() : status = Status.none;

  @override
  String toString() {
    return "$status";
  }
}

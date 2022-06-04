class ApiResponse<T> {
  Status status;
  late T data;
  late String message;

  ApiResponse.loading(this.message) : status = Status.LOADING;
  ApiResponse.completed(this.data) : status = Status.COMPLETED;
  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Pesan : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }

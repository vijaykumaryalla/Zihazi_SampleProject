class ApiResponse<R,E>{
  R? response;
  E? error;
  ApiResponse.success(this.response);
  ApiResponse.error(this.error);
}
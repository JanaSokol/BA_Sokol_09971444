import {Injectable} from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class ApplicationError {
  error: any;
  occurred: boolean = false;
  message: String = "";

  /**
   * Gets called if an error occurs during loading data from the backend.
   *
   * @param error representing an error from the backend
   */
  handleError(error: any) {
    this.error = error;
    this.occurred = true;

    if (!!!error.error) {
      this.message = 'Unknown error occurred';
      console.log(error);
      return;
    } else if (error.status === 0) {
      this.message = 'Could not reach backend!';
      return;
    }

    if (error.status === 404) {
      this.message = error.message;
      this.occurred = false;
    }

    this.message = typeof error.error === 'object' ? ` ${error.error.message}` : ` ${error.error}`;
  }


  isBackendReachable(): boolean {
    if (this.error && this.error.status === 0) {
      return false;
    } else {
      return true;
    }
  }
}

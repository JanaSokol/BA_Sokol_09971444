import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Globals} from "../global/globals";
import {Observable} from "rxjs";


@Injectable({
  providedIn: 'root'
})
export class ServiceService {

  private baseURI: string = this.globals.backendUri;

  constructor(private httpClient: HttpClient,
              private globals: Globals) {
  }

  /**
   * Gets all available dates.
   */
  getAvailableDates(): Observable<string[]> {
    return this.httpClient.get<string[]>(this.baseURI);
  }
}

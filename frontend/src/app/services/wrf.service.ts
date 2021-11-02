import { Injectable } from '@angular/core';
import {HttpClient, HttpParams} from '@angular/common/http';
import {Globals} from "../global/globals";
import {Observable} from "rxjs";

@Injectable({
  providedIn: 'root'
})
export class WrfService {

  private wrfBaseUri:string = this.globals.backendUri + '/wrf';

  constructor(private httpClient: HttpClient,
  private globals: Globals) { }

  /**
   * Runs main script.
   */
  runMainScript(): Observable<number> {
    return this.httpClient.get<number>(this.wrfBaseUri + "/" + 31 + "/" + 10 + "/" + 2021);
  }
}

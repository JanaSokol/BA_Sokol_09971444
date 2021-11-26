import { Injectable } from '@angular/core';
import {HttpClient, HttpParams} from '@angular/common/http';
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

  getAvailableDates(): Observable<string[]>{
    return this.httpClient.get<string[]>(this.baseURI);
  }

}

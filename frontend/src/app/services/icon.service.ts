import { Injectable } from '@angular/core';
import {HttpClient, HttpParams} from "@angular/common/http";
import {Globals} from "../global/globals";
import {Observable} from "rxjs";
import {Image} from "../dtos/image";

@Injectable({
  providedIn: 'root'
})
export class IconService {

  private iconBaseUri: string = this.globals.backendUri + '/icon';

  constructor(private httpClient: HttpClient,
              private globals: Globals) {
  }

  /**
   * Runs main script.
   */
  getICONOutputByTime(date: string, visType: number): Observable<Image[]> {
    const params = new HttpParams()
      .set('date', String(date))
      .set('visType', visType)
    return this.httpClient.get<Image[]>(this.iconBaseUri, {params});
  }

}

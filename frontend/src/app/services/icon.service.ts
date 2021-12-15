import {Injectable} from '@angular/core';
import {HttpClient, HttpParams} from "@angular/common/http";
import {Globals} from "../global/globals";
import {Observable} from "rxjs";
import {WrfImage} from "../dtos/wrf-image";

@Injectable({
  providedIn: 'root'
})
export class IconService {

  private iconBaseUri: string = this.globals.backendUri + '/icon';

  constructor(private httpClient: HttpClient,
              private globals: Globals) {
  }

  /**
   * Gets ICON output by date.
   */
  getICONOutputByTime(date: string, visType: number): Observable<WrfImage[]> {
    const params = new HttpParams()
      .set('date', String(date))
      .set('visType', visType)
    return this.httpClient.get<WrfImage[]>(this.iconBaseUri, {params});
  }

}

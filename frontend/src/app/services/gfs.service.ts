import {Injectable} from '@angular/core';
import {HttpClient, HttpParams} from '@angular/common/http';
import {Globals} from "../global/globals";
import {Observable} from "rxjs";
import {Image} from "../dtos/image";

@Injectable({
  providedIn: 'root'
})
export class GfsService {

  private gfsBaseUri: string = this.globals.backendUri + '/gfs';

  constructor(private httpClient: HttpClient,
              private globals: Globals) {
  }

  /**
   * Runs main script.
   */
  getGFSOutputByTime(date: string, visType: number): Observable<Image[]> {
    const params = new HttpParams()
      .set('date', String(date))
      .set('visType', visType)
    return this.httpClient.get<Image[]>(this.gfsBaseUri, {params});
  }

}

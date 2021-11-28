import {Injectable} from '@angular/core';
import {HttpClient, HttpParams} from '@angular/common/http';
import {Globals} from "../global/globals";
import {Observable} from "rxjs";
import {SimpleGfs} from "../dtos/simple-gfs";
import {WrfImage} from "../dtos/wrf-image";

@Injectable({
  providedIn: 'root'
})
export class GfsService {

  private gfsBaseUri: string = this.globals.backendUri + '/gfs';

  constructor(private httpClient: HttpClient,
              private globals: Globals) {
  }

  /**
   * Gets GFS output by date.
   */
  getGFSOutputByTime(date: string, visType: number): Observable<WrfImage[]> {
    const params = new HttpParams()
      .set('date', String(date))
      .set('visType', visType)
    return this.httpClient.get<WrfImage[]>(this.gfsBaseUri, {params});
  }

}

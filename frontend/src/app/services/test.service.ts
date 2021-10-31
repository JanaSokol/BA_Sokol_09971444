import { Injectable } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {Observable} from "rxjs";
import {Test} from "../dtos/test";

@Injectable({
  providedIn: 'root'
})
export class TestService {

  private testBaseUri: string = 'http://localhost:8080/';

  constructor(private httpClient: HttpClient) { }

  getTestById(id:number): Observable<Test> {
    return this.httpClient.get<Test>(this.testBaseUri + '/weather/' + id);
  }
}

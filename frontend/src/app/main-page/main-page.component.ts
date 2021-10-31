import { Component, OnInit } from '@angular/core';
import {TestService} from "../services/test.service";
import {Test} from "../dtos/test";

@Component({
  selector: 'app-main-page',
  templateUrl: './main-page.component.html',
  styleUrls: ['./main-page.component.css']
})
export class MainPageComponent implements OnInit {

  constructor(private testService: TestService) { }

  ngOnInit(): void {
    console.log("HERE")
    this.loadTestById(1)
  }

  private loadTestById(id:number) {
    console.log("LETS GO")
    this.testService.getTestById(id).subscribe(
      (test: Test) => {
        console.log(test)
      },
      error => {
        console.log("FAILLLL")

      }
    )
  }
}

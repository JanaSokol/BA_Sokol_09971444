import { Component, OnInit } from '@angular/core';
import {Test} from "../dtos/test";
import {WrfService} from "../services/wrf.service";

@Component({
  selector: 'app-main-page',
  templateUrl: './main-page.component.html',
  styleUrls: ['./main-page.component.css']
})
export class MainPageComponent implements OnInit {

  constructor(private wrfService: WrfService) { }

  ngOnInit(): void {
    console.log("HERE")
  }

  runMainScript() {
    console.log("LETS GO")
    this.wrfService.runMainScript().subscribe(
      (test: number) => {
        console.log(test)
      },
      error => {
        console.log("FAILLLL")

      }
    )
  }
}

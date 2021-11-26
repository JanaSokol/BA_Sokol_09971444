import {Component, Input, OnInit} from '@angular/core';
import {Image} from "../dtos/image";

@Component({
  selector: 'app-weather-model',
  templateUrl: './weather-model.component.html',
  styleUrls: ['./weather-model.component.css']
})
export class WeatherModelComponent implements OnInit {

  @Input()
  images: Image[] = [];
  @Input()
  index: number = 0;
  currentPicture: string = "";

  constructor() { }

  ngOnInit(): void {
  }

  /**
   * Opens current clicked picture in popup.
   */
  onOpened(event: any) {
    console.log("CLICK")
    this.currentPicture = event.target.src;
  }

}

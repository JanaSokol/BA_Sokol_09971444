import {Component, Input, OnInit} from '@angular/core';
import {WrfImage} from "../../dtos/wrf-image";

@Component({
  selector: 'app-weather-model',
  templateUrl: './weather-model.component.html',
  styleUrls: ['./weather-model.component.css']
})
export class WeatherModelComponent implements OnInit {

  @Input()
  images: WrfImage[] = [];
  @Input()
  index: number = 0;
  @Input()
  visType: number = 1;

  currentPicture: string = "";

  constructor() { }

  ngOnInit(): void {
  }

}

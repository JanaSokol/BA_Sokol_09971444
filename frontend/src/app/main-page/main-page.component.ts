import {Component, OnInit} from '@angular/core';
import {GfsService} from "../services/gfs.service";
import {Image} from "../dtos/image";
import {Gfs} from "../dtos/gfs";
import {FormBuilder, FormGroup} from "@angular/forms";
import {IconService} from "../services/icon.service";
import {Icon} from "../dtos/icon";
import {ServiceService} from "../services/service.service";

@Component({
  selector: 'app-main-page',
  templateUrl: './main-page.component.html',
  styleUrls: ['./main-page.component.css']
})
export class MainPageComponent implements OnInit {


  date: string = '2021-11-25';
  gfs: Gfs = new Gfs("", []);
  icon: Icon = new Icon("", []);
  index: number = 0;
  dates: string[] = [];

  public form: FormGroup;


  constructor(private gfsService: GfsService, private iconService: IconService, private formBuilder: FormBuilder, private service: ServiceService) {
    this.form = this.formBuilder.group({
      visType: 1,
      date: 0,
    })
  }

  ngOnInit(): void {
    this.getAvailableDates();
  }

  getOutputByTime() {
    this.index = 0;
    let currentDate = this.dates[this.form.controls.date.value];
    let visType = this.form.controls.visType.value;
    this.gfsService.getGFSOutputByTime(currentDate, visType).subscribe(
      (images: Image[]) => {
        this.gfs.start = this.date;
        this.gfs.images = images;
        this.gfs.images.sort((b, a) => new Date(b.dateTime).getTime() - new Date(a.dateTime).getTime());
      },
      error => {
        console.log("FAILLLL")

      }
    )
    this.iconService.getICONOutputByTime(currentDate, visType).subscribe(
      (images: Image[]) => {
        this.icon.start = this.date;
        this.icon.images = images;
        this.icon.images.sort((b, a) => new Date(b.dateTime).getTime() - new Date(a.dateTime).getTime());
      },
      error => {
        console.log("FAILLLL")

      }
    )
  }

  getAvailableDates() {
    this.service.getAvailableDates().subscribe(
      (dates: string[]) => {
        dates.sort((a, b) => new Date(b).getTime() - new Date(a).getTime());
        this.dates = dates;
        this.getOutputByTime();
      }
    )
  }

  public next() {
    this.index++;
  }

  public previous() {
    this.index--;
  }
}

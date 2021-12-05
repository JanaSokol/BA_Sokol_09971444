import {AfterViewInit, Component, OnInit} from '@angular/core';
import {GfsService} from "../../services/gfs.service";
import {SimpleGfs} from "../../dtos/simple-gfs";
import {FormBuilder, FormGroup} from "@angular/forms";
import {IconService} from "../../services/icon.service";
import {SimpleIcon} from "../../dtos/simple-icon";
import {ServiceService} from "../../services/service.service";
import {ApplicationError} from "../../global/applicationError";
import {WrfImage} from "../../dtos/wrf-image";

@Component({
  selector: 'app-main-page',
  templateUrl: './main-page.component.html',
  styleUrls: ['./main-page.component.css']
})
export class MainPageComponent implements OnInit {


  // Error Handling
  error = new ApplicationError();

  gfs: SimpleGfs = new SimpleGfs( [], []);
  icon: SimpleIcon = new SimpleIcon( [], []);
  currentlyLoadedGfs: WrfImage[] = [];
  currentlyLoadedIcon: WrfImage[] = [];
  index: number = 0;
  visType: number = 1;
  dates: string[] = [];
  form: FormGroup;


  constructor(private gfsService: GfsService, private iconService: IconService, private formBuilder: FormBuilder, private service: ServiceService) {
    this.form = this.formBuilder.group({
      visType: 1,
      date: 0,
    })
  }

  /**
   * Gets all available dates upon loading the page.
   */
  ngOnInit(): void {
    this.getAvailableDates();
  }

  /**
   * Get the WRF visualized output by chosen date.
   */
  getOutputByTime() {
    this.index = 0;
    let currentDate = this.dates[this.form.controls.date.value];
    this.visType = this.form.controls.visType.value;
    this.gfsService.getGFSOutputByTime(currentDate, this.visType).subscribe(
      (gfsImages: WrfImage[]) => {
        gfsImages.sort((b, a) => new Date(b.dateTime).getTime() - new Date(a.dateTime).getTime());
        if(this.visType === 1) {
          this.gfs.gradsImages = gfsImages;
        }else if(this.visType === 2) {
          this.gfs.nclImages = gfsImages;
        }
        this.currentlyLoadedGfs = gfsImages;
      },
      error => {
        // TODO
        this.error.handleError(error);
        console.log("FAILLLL")
      }
    )
    this.iconService.getICONOutputByTime(currentDate, this.visType).subscribe(
      (iconImages: WrfImage[]) => {
        iconImages.sort((b, a) => new Date(b.dateTime).getTime() - new Date(a.dateTime).getTime());
        if(this.visType === 1) {
          this.icon.gradsImages = iconImages;
        }else if(this.visType === 2) {
          this.icon.nclImages = iconImages;
        }
        this.currentlyLoadedIcon = iconImages;
      },
      error => {
        this.error.handleError(error);
        // TODO
        console.log("FAILLLL")
      }
    )
  }

  /**
   * Loads all available dates.
   */
  getAvailableDates() {
    this.service.getAvailableDates().subscribe(
      (dates: string[]) => {
        dates.sort((a, b) => new Date(b).getTime() - new Date(a).getTime());
        this.dates = dates;
        this.getOutputByTime();
      },
      error => {
        // TODO
        console.log("FAILLLL")
      }
    )
  }

  /**
   * Increases index by one.
   */
  public next() {
    this.index++;
  }

  /**
   * Decreases index by one.
   */
  public previous() {
    this.index--;
  }

}

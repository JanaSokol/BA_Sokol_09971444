import {Component, OnInit} from '@angular/core';
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

  gfs: SimpleGfs = new SimpleGfs([], []);
  icon: SimpleIcon = new SimpleIcon([], []);
  currentlyLoadedCaseOne: WrfImage[] = [];
  currentlyLoadedCaseTwo: WrfImage[] = [];
  index: number = 0;
  visType: number = 1;
  dates: string[] = [];
  form: FormGroup;
  radio: FormGroup;
  compType: boolean = true;
  loaded: boolean = false;
  display: number = 1;


  constructor(private gfsService: GfsService, private iconService: IconService, private formBuilder: FormBuilder, private service: ServiceService) {
    this.form = this.formBuilder.group({
      visType: 1,
      date: 0,
    })
    this.radio = this.formBuilder.group({
      comparison: "1",
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
    this.getGfsData(1);
    this.getGfsData(2);
    this.getIconData(1);
    this.getIconData(2);


  }

  getIconData(type: number) {
    this.iconService.getICONOutputByTime(this.dates[this.form.controls.date.value], type).subscribe(
      (iconImages: WrfImage[]) => {
        iconImages.sort((b, a) => new Date(b.dateTime).getTime() - new Date(a.dateTime).getTime());
        if (type === 1) {
          this.icon.gradsImages = iconImages;
        } else if (type === 2) {
          this.icon.nclImages = iconImages;
        }
        this.showCorrectComparison();
      },
      error => {
        this.error.handleError(error);
      }
    )

  }

  getGfsData(type: number) {
    this.gfsService.getGFSOutputByTime(this.dates[this.form.controls.date.value], type).subscribe(
      (gfsImages: WrfImage[]) => {
        gfsImages.sort((b, a) => new Date(b.dateTime).getTime() - new Date(a.dateTime).getTime());
        if (type === 1) {
          this.gfs.gradsImages = gfsImages;
        } else if (type === 2) {
          this.gfs.nclImages = gfsImages;
        }
        this.showCorrectComparison();
      },
      error => {
        this.error.handleError(error);
      }
    )
  }

  showCorrectComparison() {
    switch (this.compType) {
      case true : {
        if (this.form.controls.visType.value == "1") {
          this.currentlyLoadedCaseOne = this.gfs.gradsImages;
          this.currentlyLoadedCaseTwo = this.icon.gradsImages;
          this.display = 1;
        }
        if (this.form.controls.visType.value == "2") {
          this.currentlyLoadedCaseOne = this.gfs.nclImages;
          this.currentlyLoadedCaseTwo = this.icon.nclImages;
          this.display = 2;
        }
        break;
      }
      case false : {
        if (this.form.controls.visType.value == "1") {
          this.currentlyLoadedCaseOne = this.gfs.gradsImages;
          this.currentlyLoadedCaseTwo = this.gfs.nclImages;
        }
        if (this.form.controls.visType.value == "2") {
          this.currentlyLoadedCaseOne = this.icon.gradsImages;
          this.currentlyLoadedCaseTwo = this.icon.nclImages;
        }
        break;
      }
      default: {
        this.currentlyLoadedCaseOne = this.gfs.gradsImages;
        this.currentlyLoadedCaseTwo = this.icon.gradsImages;
        break;
      }
    }
    if (this.currentlyLoadedCaseTwo.length != 0 && this.currentlyLoadedCaseOne.length != 0) this.loaded = true;

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
        this.error.handleError(error);
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

  public test() {
    this.compType = !this.compType;
    this.showCorrectComparison();
  }
}

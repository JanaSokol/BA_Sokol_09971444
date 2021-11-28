import {WrfImage} from "./wrf-image";

export class SimpleGfs {
  constructor(
    public gradsImages: WrfImage[],
    public nclImages: WrfImage[]
  ) {
  }
}

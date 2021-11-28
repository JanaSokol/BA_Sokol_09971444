import {WrfImage} from "./wrf-image";

export class SimpleIcon {
  constructor(
    public gradsImages: WrfImage[],
    public nclImages: WrfImage[]
  ) {
  }
}

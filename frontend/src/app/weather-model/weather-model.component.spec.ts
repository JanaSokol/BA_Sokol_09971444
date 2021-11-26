import { ComponentFixture, TestBed } from '@angular/core/testing';

import { WeatherModelComponent } from './weather-model.component';

describe('WeatherModelComponent', () => {
  let component: WeatherModelComponent;
  let fixture: ComponentFixture<WeatherModelComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ WeatherModelComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(WeatherModelComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

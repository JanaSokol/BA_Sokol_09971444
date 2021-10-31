import { TestBed } from '@angular/core/testing';

import { WrfService } from './wrf.service';

describe('WrfService', () => {
  let service: WrfService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(WrfService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});

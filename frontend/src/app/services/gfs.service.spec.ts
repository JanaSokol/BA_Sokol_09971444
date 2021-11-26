import { TestBed } from '@angular/core/testing';

import { GfsService } from './gfs.service';

describe('WrfService', () => {
  let service: GfsService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(GfsService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});

//TODO: TUWien Project Code cite?

import {Injectable} from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class Globals {
  readonly backendUri: string = 'http://localhost:8080/weather';

  /**
   * Get day, month and year from date - in a readable format.
   * @param date containing day, month, year and time.
   */
  getDate(date: string): string {
    const d = new Date(date.split('T')[0]);

    const addLead = (n: number) => n <= 9 ? `0${n}` : n;

    return `${addLead(d.getDate())}.${addLead(d.getMonth() + 1)}.${addLead(d.getFullYear())}`;
  }

  /**
   * Get time from date.
   * @param date containing day, month, year and time.
   */
  getTime(date: string): string {
    return date.split('T')[1].substring(0, 5);
  }
}

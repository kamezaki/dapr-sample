export class LoggingService {
  #logger = console;

  log(message?: any, ...optionalParams: any[]): void {
    this.#logger.debug(message, optionalParams);
  }

  info(message?: any, ...optionalParams: any[]): void {
    this.#logger.info(message, optionalParams);
  }

  warn(message?: any, ...optionalParams: any[]): void {
    this.#logger.warn(message, optionalParams);
  }

  error(message?: any, ...optionalParams: any[]): void {
    this.#logger.error(message, optionalParams);
  } 
}

export default new LoggingService();

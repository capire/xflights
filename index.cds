// Public API for easy imports
using from './srv/data-products';
using from './srv/srv-events';
using from './srv/workarounds';

// simulate cds export
annotate sap.capire.flights.data with @cds.external;

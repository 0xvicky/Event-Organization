//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

contract EventOrganization{
   
  struct Event{
    string eventName;
    address payable organizer;
    uint date;
    uint ticketPrice;
    uint ticketCount;
    uint ticketRemain;
    }
  uint eventId;
  uint chairmanFee;
  uint public chairmanBalance;
  uint organizerBalance;
  address payable public chairman;
  mapping(uint=>Event) public idToEvent;//This is pointint from event id to event struct..
  mapping(address=>uint) public organizerToBalance;
  mapping(address =>mapping(uint=>uint)) public addressToEvent;//This mapping is pointing from audience address to event id to no of tickets\
  constructor(uint _chairmanFee){
      chairman = payable(msg.sender);
      chairmanFee = _chairmanFee;
  }
  function createEvent(string memory _eventName, uint _date, uint _ticketPrice, uint _ticketCount)external payable{
    require(msg.sender != chairman,"Chairman cannot organize event");
    require(msg.value == chairmanFee,"Pay the fee");
    require(_date>block.timestamp,"Invalid Date");
    require(_ticketCount>5,"Ticket cannot be less than 5.");
    chairman.transfer(chairmanFee);
    chairmanBalance+=uint(msg.value);
    idToEvent[eventId] = Event(_eventName, payable(msg.sender), _date,_ticketPrice, _ticketCount,_ticketCount);
    organizerToBalance[msg.sender] = organizerBalance;
    eventId++;
  }
  function buyTicket(uint _eventId, uint _qtyTickets) external payable {
    Event storage _event = idToEvent[_eventId];
    require(msg.sender != _event.organizer,"Organizer can't buy tickets.");
    require(_event.date != 0,"Event doesn't exist");
    require(msg.value == _event.ticketPrice*_qtyTickets,"Insufficient Money");
    require(block.timestamp<_event.date,"The event occured already");
    require(_qtyTickets<=_event.ticketRemain,"Tickets are not enough...");
    (_event.organizer).transfer(msg.value);
    organizerToBalance[_event.organizer]+=uint(msg.value);
    _event.ticketRemain-=_qtyTickets;
    addressToEvent[msg.sender][_eventId] += _qtyTickets;

  }

  function transferTickets(address _to,uint _id, uint _noOfTickets) external {
      require(idToEvent[_id].date != 0,"Event doesn't exist");
      require(block.timestamp<idToEvent[_id].date,"The event occured already");
      require(addressToEvent[msg.sender][_id] >= _noOfTickets,"Don't have enough tickets");
      addressToEvent[msg.sender][_id]-=_noOfTickets;
      addressToEvent[_to][_id]+=_noOfTickets;

  }





}
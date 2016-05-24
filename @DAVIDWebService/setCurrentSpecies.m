function xReturn = setCurrentSpecies(obj,args0)
%setCurrentSpecies(obj,args0)
%
%     Input:
%       args0 = (string)
%   
%     Output:
%       return = (string)

% Build up the argument lists.
values = { ...
   args0, ...
   };
names = { ...
   'args0', ...
   };
types = { ...
   '{http://www.w3.org/2001/XMLSchema}string', ...
   };

% Create the message, make the call, and convert the response into a variable.
soapMessage = createSoapMessage( ...
    'http://service.session.sample', ...
    'setCurrentSpecies', ...
    values,names,types,'document');
response = callSoapService( ...
    obj.endpoint, ...
    'urn:setCurrentSpecies', ...
    soapMessage);
xReturn = parseSoapResponse(response);

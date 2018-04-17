function ofdm( arch, modo, modul )

  [ v, fs ] = audioread( arch, 'native' );

    dt = 1/fs;
    longV = length( v ) * dt;
    endV = ( longV ) - dt;

    time = 0:dt:endV;

  plotOriginal( time, v );

  [ div, modulation ] = setProperties( modo, modul );
  [ v, newVector ] = getNewVector( v, modulation );

  v = setV(v);

  Ym = getInvFT(v, div);

  plotModulated(Ym, fs, modo);

end

function [ v, newVector ] = getNewVector( v, modulation )

  d2b = uint8(dec2bin(v) - '0');
  binaryVector = reshape(d2b.',[],1);

  [ x, y ] = size(binaryVector);
  compV = (x .* y ) / modulation;
  contV = reshape(binaryVector,modulation,compV);
  newVector  = double(contV);

  if modulation == 2
      v = newVector(2,:) + (newVector(1,:)*10);
  else
      v = newVector(4,:) + (newVector(3,:)*10) + newVector(2,:)*100 + newVector(1,:)*1000;
  end

end

function [ div, modulation ] = setProperties( modo, modul )

  if modo == 0
    div = 2048;
  elseif modo == 1
    div = 8192;
  end

  if modul == 0
      modulation = 2;
  elseif modul == 1
      modulation = 4;
  end

end

function plotOriginal( time, v )

  figure;
  subplot(211);
  plot(time,v);
  title('Senal original');

end

function plotModulated( Ym, fs, modo )

  longYm = length(Ym);

  t = linspace(0,longYm/fs,longYm);

  subplot(212);
  plot(t,Ym);

  if(modo == 0)
    axis([0 .25 -0.05 0.05]);
  elseif(modo == 1)
    axis([0 1 -0.1 0.1]);
  end

end

function Ym = getInvFT( v, div )

  invFourier = ifft(v);
    an = real(invFourier);
    bn = imag(invFourier);
    N = div;
    T = 0.01;
    df = 1/T;
    dt = T/N;

  for n=1:N
      Ym(n) = (an(n)*cos(2*pi*n*df*n*dt)) + (bn(n)*sin(2*pi*n*df*n*dt));
  end

end

function [ v ] = setV( v )

  v(v==0) = complex(1, 1);
  v(v==1) = complex(-1, 1);
  v(v==10) = complex(-1, -1);
  v(v==11) = complex(1, -1);
  v(v==100) = complex(3, 1);
  v(v==101) = complex(1, 3);
  v(v==110) = complex(3, 3);
  v(v==111) = complex(-3, 1);
  v(v==1000) = complex(-3, 3);
  v(v==1001) = complex(-1, 3);
  v(v==1010) = complex(-3, -1);
  v(v==1011) = complex(-3, -3);
  v(v==1100) = complex(-1, -3);
  v(v==1101) = complex(3, -1);
  v(v==1110) = complex(1, -3);
  v(v==1111) = complex(3, -3);

end

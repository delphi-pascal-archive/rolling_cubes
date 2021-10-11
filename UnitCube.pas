unit UnitCube;
                                                                                {
                             PAR CARIBENSILA
                              f�vrier 2007                                      }
INTERFACE

  uses
    Windows, ExtCtrls, Controls, Classes, jpeg, SysUtils, Graphics, Forms, math;

  type
    TCube = class(TImage)
    private
      fTabloBtm   : array[0..5] of TBitmap;
      fIndexFace  : Integer;
      fTailleCube : Integer;
      fVitesse    : Integer;
      fVirtuel    : Boolean;
      procedure SetVirtuel(Valeur : Boolean);
      procedure SetTailleCube(Valeur : Integer);
      procedure SetVitesse(Valeur : Integer);
      procedure CubeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      procedure CubeDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    public
      constructor Create(AOwner:TComponent); override;
      destructor  Destroy; override;
      procedure ChargerJpg(Index: Integer; UnJpeg: TJPEGImage);
      property  Taille  : Integer read fTailleCube write SetTailleCube;
      property  Vitesse : Integer read fVitesse write SetVitesse;
      property  Virtuel : Boolean read fVirtuel write SetVirtuel;
  end;


IMPLEMENTATION

  type
      TTab = array[0..23,1..4] of byte;

  const                                    //Ce tableau permet de conna�tre les photos pr�sentes sur chaque face du cube.
     TabloRotation: TTab= ((13, 5, 9,17),  //Chaque ligne repr�sente le N� de la face visible..
                           (18,14, 6,10),  //..et chaque colonne les faces mitoyennes dans..
                           (11,19,15, 7),  //..l'ordre: "Haut,Droite,Bas,Gauche".
                           ( 8,12,20,16),  //Bon... Je sais, c'est pas clair...
                           (14,21,12, 1),  //Mais pour faire ce tableau, j'ai fabriqu� un petit cube en papier.
                           ( 2,15,22, 9),  //Et je l'envoie au plus offrant. lol
                           (10, 3,16,23),
                           (24,11, 4,13),
                           ( 1, 6,23,20),
                           (17, 2, 7,24),
                           (21,18, 3, 8),
                           ( 5,22,19, 4),
                           (23, 8, 1,18),
                           (19,24, 5, 2),
                           ( 3,20,21, 6),
                           ( 7, 4,17,22),
                           (16, 1,10,21),
                           (22,13, 2,11),
                           (12,23,14, 3),
                           ( 4, 9,24,15),
                           (15,17,11, 5),
                           ( 6,16,18,12),
                           ( 9, 7,13,19),
                           (20,10, 8,14));

    NbreImages : Integer = 30; //Nombre d'images calcul�es pour une animation.

  var
    MousePoint: TPoint; // Pour le drag'n drop.



constructor TCube.Create(AOwner:TComponent);
  begin
  inherited;
  fTailleCube      := 0;    // Valeur par d�faut.
  fIndexFace       := 0;    //         "
  fVirtuel         := true; //         "
  self.AutoSize    := true;
  self.OnMouseDown := CubeMouseDown;
  self.OnDragOver  := CubeDragOver;
end;



destructor TCube.Destroy;
  var
      i : integer;
  begin
  for i := 0 to 5 do FreeAndNil(fTabloBtm[i]);
  Inherited;
end;



procedure TCube.SetVirtuel(Valeur : Boolean);
  begin
  fVirtuel := Valeur;
end;



procedure TCube.SetTailleCube(Valeur : Integer);
  begin
  fTailleCube := Valeur;
end;



procedure TCube.SetVitesse(Valeur : Integer);
  begin
  fVitesse := Valeur;
end;



procedure TCube.ChargerJpg(Index: Integer; UnJpeg : TJpegImage);
  begin
  if fTailleCube = 0 then exit;//La taille du cube doit �tre initialis�e avant de charger les images.
  if (Index>=0) and (Index<=5) then begin
     fTabloBtm[Index] := TBitmap.Create;
     fTabloBtm[Index].PixelFormat := pf24bit;
     fTabloBtm[Index].Height      := fTailleCube;
     fTabloBtm[Index].Width       := fTailleCube;
     fTabloBtm[Index].Canvas.StretchDraw(fTabloBtm[Index].Canvas.ClipRect,UnJpeg);
  end;
  if assigned(fTabloBtm[5]) then Picture.Assign(fTabloBtm[fIndexFace]);
end;



procedure TCube.CubeDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
  var
      tempPoint : TPoint;
  Begin
  getcursorpos(tempPoint);
  with (Source as TControl) do begin
    Top :=Round((Parent as TControl).screentoclient(tempPoint).Y)-MousePoint.Y;
    Left:=Round((Parent as TControl).screentoclient(tempPoint).X)-MousePoint.X;
  end;
end;



PROCEDURE TCube.CubeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

  VAR
      Largeur    : Integer;
      Decalage   : Integer;
      Arete      : Integer;
      BorneBasse : Integer;
      BorneHaute : Integer;
      i          : Integer;
      L, T       : Integer;
      BtmImage   : TBitmap;
      BtmFace    : TBitmap;
      BtmSuivant : TBitmap;
      Angle      : extended;
      Pas        : Extended;

                  {Quelques proc�dures imbriqu�es pour �viter des variables globales.}


                    {1�re proc�dure imbriqu�e.}
                  procedure Calculer;
                    begin
                    Angle   := Angle - 3.1415926536 / (NbreImages shl 1);
                    Largeur := round((fTailleCube * 1.4142135623731) * Cos(abs(Angle))); // 1,4142135623731 := Sqrt(2)
                    Arete   := round(cos(0.7853981634 - Angle) * fTailleCube); //round(cos(Pi/4-Angle)...
                  end;


                    {2�me proc�dure imbriqu�e.}
                  procedure Afficher;
                    begin
                    self.Picture.Bitmap.Assign(BtmImage);
                    (self.Owner as TForm).Refresh;
                    Sleep(fVitesse);
                  end;


                    {3�me proc�dure imbriqu�e.}
                  procedure BmpRotation(BmpSourc: TBitmap; Angle: Extended);
                    {Rotation selon l'axe Z.}
                    var
                        ScanCible, ScanSourc : array of pointer;
                        CoinX, CoinY, X, Y, X2, Y2, T1 : integer;
                        Xcosr,Xsinr,Ysinr,Ycosr,Sinr,Cosr: integer;
                        Sinus, Cosin : Extended;
                    begin
                    while Angle > 360 do Angle := Angle-360; //Il faut 0 <= Angle <= 360
                    Angle := Angle*0.0174532925199433; // De degr�s en radians.
                    SinCos(Angle ,Sinus, Cosin);
                    BtmSuivant.Height := round(BmpSourc.Height * abs(Sinus) + BmpSourc.Height * abs(Cosin));
                    BtmSuivant.Width  := BtmSuivant.Height; //La taille de BmpDest est calcul�e pour contenir exactement  la nouvelle image.
                    BtmSuivant.Canvas.Brush.Color := 65535;//Couleur de transparence.
                    BtmSuivant.Canvas.FillRect(BtmSuivant.Canvas.ClipRect);
                    BtmSuivant.TransparentColor := 65535;
                    {CoinX et CoinY sont les coordonn�es du coin sup�rieur gauche de la photo dans l'image finale.}
                    CoinX := 0;
                    CoinY := 0;
                    if (Angle>=0)and(Angle<=1.5707963267949)then CoinX := round(BmpSourc.Height * abs(Sinus));
                    if (Angle >1.5707963267949)and(Angle<=3.14159265358979)then begin
                        CoinX := BtmSuivant.Width-1;
                        CoinY := round(BmpSourc.Height * abs(Cosin));  end;
                    if (Angle>3.14159265358979)and(Angle<=4.71238898038469)then begin
                        CoinX := round(BmpSourc.Height * abs(Cosin));
                        CoinY := BtmSuivant.Height-1;  end;
                    if (Angle>4.71238898038469)and(Angle<=6.28318530717959)then CoinY := round(BmpSourc.Height * abs(Sinus))-1;
                    {Decalage servira � replacer le TImage de fa�on � ce que l'image semble tourner sur elle-m�me.}
                    Decalage := (BtmSuivant.Height - BmpSourc.Height) shr 1;
                    SetLength(ScanCible,BtmSuivant.Height);
                    SetLength(ScanSourc,BmpSourc.Height);
                    for Y:=BtmSuivant.Height-1 downto 0 do ScanCible[Y] := BtmSuivant.scanline[Y];
                    for Y:=BmpSourc.Height  -1 downto 0 do ScanSourc[Y] := BmpSourc.scanline[Y];
                    Sinr := round(Sinus * $10000);//Les valeurs sinus et cosinus en Integer pour les d�calages.
                    Cosr := round(Cosin * $10000);
                    for X:=BmpSourc.Width-1 downto 0 do begin
                      Xcosr:=X*Cosr;
                      Xsinr:=X*Sinr;
                      Y:=BmpSourc.Height-1;
                      Ysinr:=Y*Sinr;
                      Ycosr:=Y*Cosr;
                      for Y:=BmpSourc.Height-1 downto 0 do begin
                        T1 := Xcosr-Ysinr;
                        if T1>=0 then X2 := CoinX + T1 shr 16 else X2 := CoinX - (-T1) shr 16; //Evite de d�caler les valeurs n�gatives.
                        T1 := Ycosr+Xsinr;
                        if T1>=0 then Y2 := CoinY + T1 shr 16 else Y2 := CoinY - (-T1) shr 16;
                        {X2 et Y2 sont maintenant les coordonn�es du pixel de destination.}
                        dec(Ysinr,Sinr);
                        dec(Ycosr,Cosr);
                        if X2>-1 then
                        if X2<BtmSuivant.Width then
                        if Y2>-1 then
                        if Y2<BtmSuivant.Height then begin //Si X2 et Y2 sont bien dans le Bitmap de destination...
                          asm //Le code ASM original comment� en anglais est visible � : http://www.Planet-Source-Code.com/vb/scripts/ShowCode.asp?txtCodeId=853&lngWId=7
                            mov edx,ScanSourc;
                            mov eax,Y;
                            mov ecx,[edx+eax*4];
                            mov edx,X;
                            lea edx,[edx*2+edx];
                            mov ax,[edx+ecx];
                            push ebx;
                            mov bl,byte [edx+ecx+2];
                            mov ecx,ScanCible;
                            mov edx,Y2;
                            mov ecx,[edx*4+ecx];
                            mov edx,X2;
                            lea edx,[edx*2+edx];
                            mov word [ecx+edx],ax;
                            mov byte [ecx+edx+2],bl;
                            or edx,edx;
                            jz @end;
                            mov word [ecx+edx-3],ax;
                            mov byte [ecx+edx-1],bl;
                            @end:
                            pop ebx;
                          end;
                        end;
                      end;
                    end;
                  end;


                  {4�me proc�dure imbriqu�e.}
                  procedure OrienterFaceSuivante;
                  {D�termine la rotation � appliquer au bitmap de l'image suivante.
                   C'est cette proc�dure qui rend r�aliste le comportement du cube.}
                    begin
                    case fIndexFace mod 4 of
                      0: BtmSuivant.Assign(fTabloBtm[fIndexFace shr 2]     );
                      1: BmpRotation      (fTabloBtm[fIndexFace shr 2],  90);
                      2: BmpRotation      (fTabloBtm[fIndexFace shr 2], 180);
                      3: BmpRotation      (fTabloBtm[fIndexFace shr 2], 270);
                    end;
                  end;


                  {5�me proc�dure imbriqu�e.}
                  procedure RotZ;
                    begin
                    BmpRotation(BtmFace, Pas);
                    self.Left := L-Decalage; //On repositionne le TImage.
                    self.Top  := T-Decalage;
                    self.Picture.Bitmap.Assign(BtmSuivant);
                    self.Refresh;
                    Sleep(fVitesse);
                  end;



  BEGIN //PROCEDURE TCube.CubeMouseDown
  Self.BringToFront; //Pour survoler les autres cubes.
  BorneBasse := Self.Height div 5;
  BorneHaute := BorneBasse * 4;

  {Si clic au milieu du compo, c'est un Drag'n Drop.}
  if (X>=BorneBasse) and (X<=BorneHaute) and (Y>=BorneBasse) and (Y<=BorneHaute)  then begin
    begindrag(false,3);//Le Drag commence apr�s un mouvement de 3 pixels.
    MousePoint.X := X;
    MousePoint.Y := Y;
    Exit;
  end;

  BtmImage   := TBitmap.Create; //Sevira � recueillir les 2 images suivantes.
  BtmFace    := TBitmap.Create; // L'image de la face en train de dispara�tre.
  BtmSuivant := TBitmap.Create; // L'image de la face en train d'appara�tre.
  try
    BtmImage.pixelformat   := pf24bit;
    BtmFace.pixelformat    := pf24bit;
    BtmSuivant.pixelformat := pf24bit;
    BtmImage.Height   := fTailleCube;       BtmImage.Width   := fTailleCube;
    BtmFace.Height    := fTailleCube;       BtmFace.Width    := fTailleCube;
    BtmSuivant.Height := fTailleCube;       BtmSuivant.Width := fTailleCube;
    BtmFace.Assign(self.Picture.Bitmap);
    Angle := 0.7853981634; // Pi/4
    
    {Si click dans un des coins.}
    L:= self.Left;
    T:= self.Top;
    if (X<=BorneBasse) and ((Y<=BorneBasse) or (Y>=BorneHaute)) then  //coins gauches.
    if (fVirtuel) then exit
    else begin
      if (fIndexFace div 4 > (fIndexFace-1) div 4) or (fIndexFace = 0) then fIndexFace := fIndexFace+3
      else fIndexFace := fIndexFace-1;
      self.Transparent := true;
      for i := NbreImages downto 1 do begin
        Pas := i*(90/NbreImages) + (270-90/NbreImages);
        RotZ;
      end;
      self.Transparent := false;
      Exit;
    end;
    if (X>=BorneHaute) and ((Y<=BorneBasse) or (Y>=BorneHaute)) then  //coins droits.
    if (fVirtuel) then exit
    else begin
      if fIndexFace div 4 < (fIndexFace+1) div 4  then fIndexFace := fIndexFace-3
      else fIndexFace := fIndexFace + 1;
      self.Transparent := true;
      for i := 1 to NbreImages do begin
        Pas := i*(90/NbreImages);
        RotZ;
      end;
      self.Transparent := false;
      Exit;
    end;

    {Si clic c�t� droit.}
    if (X>BorneHaute) and ((Y>BorneBasse) and (Y<BorneHaute)) then  begin //Tourne vers la droite => Face � appara�tre = TabloRotation[fIndexFace,4].
      fIndexFace := TabloRotation[fIndexFace,4] - 1;
      if (fVirtuel = true) then BtmSuivant.Assign(fTabloBtm[fIndexFace shr 2])
      else OrienterFaceSuivante;
      for i := 1 to NbreImages do begin
        Calculer;
        Decalage := (self.Width - Largeur) div 2;
        BtmImage.Width := Largeur;
        BtmImage.Canvas.StretchDraw(rect(0,0,Largeur-Arete+1,fTailleCube+1),BtmSuivant);
        BtmImage.Canvas.StretchDraw(rect(Largeur-Arete+1,0,Largeur+1,fTailleCube+1),BtmFace);
        self.Left := self.Left + Decalage;
        Afficher;
      end;
    end;

    {Si clic c�t� gauche.}
    if (X<BorneBasse) and ((Y>BorneBasse) and (Y<BorneHaute)) then  begin
      fIndexFace := TabloRotation[fIndexFace,2] - 1;
      if (fVirtuel = true) then BtmSuivant.Assign(fTabloBtm[fIndexFace shr 2])
      else OrienterFaceSuivante; //On pr�pare la face qui va appara�tre.
      for i := 1 to NbreImages do begin
        Calculer;
        Decalage := (self.Width - Largeur) div 2;
        BtmImage.Width := Largeur;
        BtmImage.Canvas.StretchDraw(rect(0,0,Arete+1,fTailleCube+1),BtmFace);
        BtmImage.Canvas.StretchDraw(rect(Arete+1,0,Largeur+1,fTailleCube+1),BtmSuivant);
        self.Left := self.Left + Decalage;
        Afficher;
      end;
    end;

    {Si clic c�t� bas.}
    if (Y>BorneHaute) and ((X>BorneBasse) and (X<BorneHaute)) then  begin
      fIndexFace := TabloRotation[fIndexFace,1] - 1;
      if (fVirtuel = true) then BtmSuivant.Assign(fTabloBtm[fIndexFace shr 2])
      else OrienterFaceSuivante; //On pr�pare la face qui va appara�tre.
      for i := 1 to NbreImages do begin
        Calculer;
        Decalage := (self.Height - Largeur) div 2;
        BtmImage.Height := Largeur;
        BtmImage.Canvas.StretchDraw(rect(0,0,fTailleCube+1,Largeur-Arete+1),BtmSuivant);
        BtmImage.Canvas.StretchDraw(rect(0,Largeur-Arete+1,fTailleCube+1,Largeur+1),BtmFace);
        self.Top := self.Top + Decalage;
        Afficher;
      end;
    end;

    {Si clic c�t� haut.}
    if (Y<BorneBasse) and ((X>BorneBasse) and (X<BorneHaute)) then  begin
      {Tourne vers le haut => Face � appara�tre = TabloRotation[fIndexFace,3].}
      fIndexFace := TabloRotation[fIndexFace,3] - 1;
      if (fVirtuel = true) then BtmSuivant.Assign(fTabloBtm[fIndexFace shr 2])
      else OrienterFaceSuivante; //On pr�pare la face qui va appara�tre.
      for i := 1 to NbreImages do begin
        Calculer;
        Decalage := (self.Height - Largeur) div 2;
        BtmImage.Height := Largeur;
        BtmImage.Canvas.StretchDraw(rect(0,0,fTailleCube+1,Arete+1),BtmFace);
        BtmImage.Canvas.StretchDraw(rect(0,Arete+1,fTailleCube+1,Largeur+1),BtmSuivant);
        self.Top := self.Top + Decalage;
        Afficher;
      end;
    end;
    self.Picture.Bitmap.Assign(BtmSuivant);

  finally
    BtmImage.Free;
    BtmFace.Free;
    BtmSuivant.Free;
  end;
END;//PROCEDURE TSimpleCube.CubeMouseDown


END.


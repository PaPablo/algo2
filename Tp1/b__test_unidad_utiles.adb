pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__test_unidad_utiles.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__test_unidad_utiles.adb");
pragma Suppress (Overflow_Check);
with Ada.Exceptions;

package body ada_main is
   pragma Warnings (Off);

   E073 : Short_Integer; pragma Import (Ada, E073, "system__os_lib_E");
   E014 : Short_Integer; pragma Import (Ada, E014, "system__soft_links_E");
   E099 : Short_Integer; pragma Import (Ada, E099, "system__fat_flt_E");
   E087 : Short_Integer; pragma Import (Ada, E087, "system__fat_llf_E");
   E024 : Short_Integer; pragma Import (Ada, E024, "system__exception_table_E");
   E047 : Short_Integer; pragma Import (Ada, E047, "ada__io_exceptions_E");
   E120 : Short_Integer; pragma Import (Ada, E120, "ada__strings_E");
   E126 : Short_Integer; pragma Import (Ada, E126, "ada__strings__maps_E");
   E049 : Short_Integer; pragma Import (Ada, E049, "ada__tags_E");
   E046 : Short_Integer; pragma Import (Ada, E046, "ada__streams_E");
   E071 : Short_Integer; pragma Import (Ada, E071, "interfaces__c_E");
   E026 : Short_Integer; pragma Import (Ada, E026, "system__exceptions_E");
   E076 : Short_Integer; pragma Import (Ada, E076, "system__file_control_block_E");
   E065 : Short_Integer; pragma Import (Ada, E065, "system__file_io_E");
   E069 : Short_Integer; pragma Import (Ada, E069, "system__finalization_root_E");
   E067 : Short_Integer; pragma Import (Ada, E067, "ada__finalization_E");
   E146 : Short_Integer; pragma Import (Ada, E146, "system__storage_pools_E");
   E140 : Short_Integer; pragma Import (Ada, E140, "system__finalization_masters_E");
   E136 : Short_Integer; pragma Import (Ada, E136, "system__storage_pools__subpools_E");
   E018 : Short_Integer; pragma Import (Ada, E018, "system__secondary_stack_E");
   E122 : Short_Integer; pragma Import (Ada, E122, "ada__strings__unbounded_E");
   E007 : Short_Integer; pragma Import (Ada, E007, "ada__text_io_E");
   E078 : Short_Integer; pragma Import (Ada, E078, "utiles_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E007 := E007 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "ada__text_io__finalize_spec");
      begin
         F1;
      end;
      E122 := E122 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "ada__strings__unbounded__finalize_spec");
      begin
         F2;
      end;
      declare
         procedure F3;
         pragma Import (Ada, F3, "system__file_io__finalize_body");
      begin
         E065 := E065 - 1;
         F3;
      end;
      E140 := E140 - 1;
      E136 := E136 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "system__storage_pools__subpools__finalize_spec");
      begin
         F4;
      end;
      declare
         procedure F5;
         pragma Import (Ada, F5, "system__finalization_masters__finalize_spec");
      begin
         F5;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (C, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      Runtime_Initialize (1);

      Finalize_Library_Objects := finalize_library'access;

      System.Soft_Links'Elab_Spec;
      System.Fat_Flt'Elab_Spec;
      E099 := E099 + 1;
      System.Fat_Llf'Elab_Spec;
      E087 := E087 + 1;
      System.Exception_Table'Elab_Body;
      E024 := E024 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E047 := E047 + 1;
      Ada.Strings'Elab_Spec;
      E120 := E120 + 1;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Tags'Elab_Spec;
      Ada.Streams'Elab_Spec;
      E046 := E046 + 1;
      Interfaces.C'Elab_Spec;
      System.Exceptions'Elab_Spec;
      E026 := E026 + 1;
      System.File_Control_Block'Elab_Spec;
      E076 := E076 + 1;
      System.Finalization_Root'Elab_Spec;
      E069 := E069 + 1;
      Ada.Finalization'Elab_Spec;
      E067 := E067 + 1;
      System.Storage_Pools'Elab_Spec;
      E146 := E146 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Storage_Pools.Subpools'Elab_Spec;
      E136 := E136 + 1;
      System.Finalization_Masters'Elab_Body;
      E140 := E140 + 1;
      System.File_Io'Elab_Body;
      E065 := E065 + 1;
      E071 := E071 + 1;
      Ada.Tags'Elab_Body;
      E049 := E049 + 1;
      E126 := E126 + 1;
      System.Soft_Links'Elab_Body;
      E014 := E014 + 1;
      System.Os_Lib'Elab_Body;
      E073 := E073 + 1;
      System.Secondary_Stack'Elab_Body;
      E018 := E018 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E122 := E122 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E007 := E007 + 1;
      E078 := E078 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_test_unidad_utiles");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      gnat_argc := argc;
      gnat_argv := argv;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   D:\GitHub\algo2\Tp1\utiles.o
   --   D:\GitHub\algo2\Tp1\test_unidad_utiles.o
   --   -LD:\GitHub\algo2\Tp1\
   --   -LD:\GitHub\algo2\Tp1\
   --   -LC:/gnat/2015/lib/gcc/i686-pc-mingw32/4.9.3/adalib/
   --   -static
   --   -lgnat
   --   -Wl,--stack=0x2000000
--  END Object file/option list   

end ada_main;
